using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GoGreen.Models;
using GoGreen.Data;
using GoGreen.Responses;
using GoGreen.Requests;
using System.Security.Claims;
using System.Net;
using Microsoft.AspNetCore.Authorization;
using GoGreen.Services;
using AutoMapper;
using Microsoft.Extensions.Logging;
using NuGet.Packaging;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class EventController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IEventService _eventService;
        private readonly IMapper _mapper;
        private readonly IImageService _imageService;
        private readonly UserBasedCollaborativeFiltering _collaborativeFiltering;
        public EventController(ApplicationDbContext context, IEventService eventService, IMapper mapper, IImageService imageService, UserBasedCollaborativeFiltering collaborativeFiltering)
        {
            _context = context;
            _eventService = eventService;
            _mapper = mapper;
            _imageService=imageService;
            _collaborativeFiltering = collaborativeFiltering;
        }

        // GET: api/Event
        [AllowAnonymous]
        //[Authorize]
        [HttpGet]
        [ServiceFilter(typeof(CustomExceptionHandler))]
        public async Task<ActionResult<IEnumerable<EventResponse>>> GetEvents(int pageIndex = 1, int pageSize = 10, string? fullTextSearch = "")
        {

            var (events, totalCount) = await _eventService.GetAllAsync(pageIndex, pageSize, fullTextSearch);

            //return Ok(events);
            var totalPages = (int)Math.Ceiling((double)totalCount / pageSize);
            var result = new EventPaginationResponse<EventResponse>
            {
                Items = (List<EventResponse>)events.ToList(),
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount,
                TotalPages = totalPages
            };
            return Ok(result);

        }

        // GET: api/Event/5
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<ActionResult<EventResponse>> GetEvent(int id)
        {

            var eevent = await _eventService.GetById(id);

            if (eevent == null)
            {
                return NotFound();
            }


            var eventResponse = _mapper.Map<EventResponse>(eevent);

            return Ok(eventResponse);

        }

        // POST: api/Event
        [Authorize]
        [HttpPost]
        [Consumes("multipart/form-data")]
        public async Task<ActionResult<EventResponse>> PostEvent([FromForm] EventRequest request, IFormFile? imageFile)
        {

            var type = await _context.EventTypes.FindAsync(request.TypeId);

            if (type == null)
            {
                return BadRequest("Type not found");
            }

            /*
            var municipality = await _context.Municipalities.FindAsync(request.MunicipalityId);

            if (municipality == null)
            {
                return BadRequest($"The Municipality with ID {request.MunicipalityId} does not exist");
            }
            */

            var createdEvent = await _eventService.Create(request);
           
            if (imageFile != null)
            {
                var image = await _imageService.SaveImage(imageFile);

                if (image != null)
                {
                    var eventImage = new EventImage
                    {
                        EventId = createdEvent.Id,
                        ImageId = image.Id
                    };

                    _context.Add(eventImage);

                    await _context.SaveChangesAsync();

                    createdEvent.EventImages.Add(eventImage); // Add created EventImage to created Event in step before

                }
            }

            return _mapper.Map<EventResponse>(createdEvent);

        }

        // PUT: api/Event/5
        [Authorize]
        [HttpPut("{id}")]
        public async Task<ActionResult<EventResponse>> PutEvent(int id, [FromBody] EventRequest request)
        {

            if (!await CheckPermisionAsync(id))
            {
                return BadRequest("The user has no permission for this action");
            }

            var updatedEvent = await _eventService.Update(id, request);


            return _mapper.Map<EventResponse>(updatedEvent);
        }

        // DELETE: api/Event/5
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {
            
            if (!await CheckPermisionAsync(id))
            {
                return BadRequest("The user has no permission for this action");
            }

            var isDeleted = await _eventService.Delete(id);

            if (!isDeleted)
            {
                return NotFound();
            }

            return NoContent();
        }

        [Authorize]
        [HttpPut("{eventId}/Image")]
        [Consumes("multipart/form-data")]
        public async Task<ActionResult<EventResponse>> AddEventImage(int eventId, IFormFile imageFile)

        {
            if (!await CheckPermisionAsync(eventId))
            {
                return BadRequest("The user has no permission for this action");
            }

            var @event = await _context.Events
                .Where(e => e.Id == eventId)
                .Include(a => a.EventImages)
                    .ThenInclude(ei => ei.Image)
                .FirstOrDefaultAsync();

            if (@event == null)
            {
                return NotFound();
            }

            if (imageFile != null)
            {
                var image = await _imageService.SaveImage(imageFile);

                if (image != null)
                {
                    var eventImage = new EventImage
                    {
                        EventId = @event.Id,
                        ImageId = image.Id
                    };

                    _context.Add(eventImage);

                    await _context.SaveChangesAsync();

                    @event.EventImages.Add(eventImage); // Add created EventImage to created Event in step before

                }
            }

            return _mapper.Map<EventResponse>(@event);


        }


        // DELETE: api/Event/5/Image/2
        [Authorize]
        [HttpDelete("{eventId}/Image/{imageId}")]
        public async Task<IActionResult> DeleteEventImage(int eventId, int imageId )
        {

            if (!await CheckPermisionAsync(eventId))
            {
                return BadRequest("The user has no permission for this action");
            }

            var @event = await _context.Events
                .Where(e => e.Id == eventId)
                .Include(e => e.EventImages)
                    .ThenInclude(ei => ei.Image)
                .FirstOrDefaultAsync();

            if (@event == null)
            {
                return NotFound();
            }

            var eventImage = @event.EventImages.FirstOrDefault(ei => ei.ImageId == imageId);

            if (eventImage == null)
            {
                return NotFound();
            }

            @event.EventImages.Remove(eventImage);
            await _context.SaveChangesAsync();

            _imageService.DeleteImage(eventImage.Image.FileName);


            return NoContent();
        }

        [Authorize(Roles = "super-admin")]
        [HttpPost("Create-Recommendation")]
        public IActionResult GetRecommendations(string userId)
        {
            var recommendations = _collaborativeFiltering.GetRecommendedEventsForUserAsync(userId);

            // Return the recommendations to the client
            return Ok(recommendations);
        }

        private async Task<bool> CheckPermisionAsync(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);


            if (string.IsNullOrEmpty(userId))
            {
                return false;
            }

            var user = await _context.User.Include(e => e.Municipality).FirstOrDefaultAsync(u => u.Id == userId);
            var data = await _context.Events
                        .Where(a => a.MunicipalityId == user.MunicipalityId)
                        .Where(a => a.Id == id)
                        .FirstOrDefaultAsync();

            if (data == null)
            {
                return false;
            }

            return true;

        }

    }
}
