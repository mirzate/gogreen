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
        public EventController(ApplicationDbContext context, IEventService eventService, IMapper mapper, IImageService imageService)
        {
            _context = context;
            _eventService = eventService;
            _mapper = mapper;
            _imageService=imageService;
        }

        // GET: api/Event
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EventResponse>>> GetEvents(int pageIndex = 1, int pageSize = 100)
        {

            var (events, totalCount) = await _eventService.GetAllAsync(pageIndex, pageSize);

            //return Ok(events);
            
            var result = new EventPaginationResponse<EventResponse>
            {
                Items = (List<EventResponse>)events.ToList(),
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount
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
        [HttpPost]
        [Consumes("multipart/form-data")]
        public async Task<ActionResult<EventResponse>> PostEvent([FromForm] EventRequest request, IFormFile imageFile)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var type = await _context.EventTypes.FindAsync(request.TypeId);

            if (type == null)
            {
                return BadRequest("Type not found");
            }


            var municipality = await _context.Municipalities.FindAsync(request.MunicipalityId);

            if (municipality == null)
            {
                return BadRequest($"The Municipality with ID {request.MunicipalityId} does not exist");
            }


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
        [HttpPut("{id}")]
        public async Task<ActionResult<EventResponse>> PutEvent(int id, [FromBody] EventRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var updatedEvent = await _eventService.Update(id, request);


            return _mapper.Map<EventResponse>(updatedEvent);
        }

        // DELETE: api/Event/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {

            var isDeleted = await _eventService.Delete(id);

            if (!isDeleted)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpPut("{eventId}/Image")]
        [Consumes("multipart/form-data")]
        public async Task<ActionResult<EventResponse>> AddEventImage(int eventId, IFormFile imageFile)

        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var @event = await _context.Events
                .Where(e => e.Id == eventId && e.UserId == userId)
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
        [HttpDelete("{eventId}/Image/{imageId}")]
        public async Task<IActionResult> DeleteEventImage(int eventId, int imageId )
        {
            
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var @event = await _context.Events
                .Where(e => e.Id == eventId && e.UserId == userId)
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


    }
}
