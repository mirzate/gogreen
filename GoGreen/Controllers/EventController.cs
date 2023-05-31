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

        public EventController(ApplicationDbContext context, IEventService eventService, IMapper mapper)
        {
            _context = context;
            _eventService = eventService;
            _mapper = mapper;
        }

        // GET: api/Event
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EventResponse>>> GetEvents(int pageIndex = 1, int pageSize = 10)
        {

            var (events, totalCount) = await _eventService.GetAllAsync(pageIndex, pageSize);

            return Ok(events);

            var result = new EventPaginationResponse<EventResponse>
            {
                Items = (List<EventResponse>)events,
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
        public async Task<ActionResult<EventResponse>> PostEvent([FromBody] EventRequest request)
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

            var eevent = _mapper.Map<EventRequest>(request);

            var createdEvent = await _eventService.Create(eevent);

            return _mapper.Map<EventResponse>(createdEvent);

            /*
            var @event = new Event
            {
                Title = request.Title,
                Description = request.Description,
                DateFrom = request.DateFrom,
                DateTo= request.DateTo,
                TypeId = request.TypeId,
                MunicipalityId = request.MunicipalityId,
                UserId = userId,
            };

            _context.Add(@event);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEvent), new { id = @event.Id }, @event);
            */
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

        private bool EventExists(int id)
        {
            return _context.Events.Any(e => e.Id == id);
        }
    }
}
