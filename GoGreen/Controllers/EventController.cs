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
            /*
            var events = await _context.Events.ToListAsync();
            var eventResponses = events.Select(e => new EventResponse
            {
                Id = e.Id,
                Title = e.Title,
                Description = e.Description,
                DateFrom = e.DateFrom,
                DateTo = e.DateTo,
                Active = e.Active,
                EventType = e.EventType,
                Municipality = e.Municipality,
                Images = e.Images
            }).ToList();

            return eventResponses;
            */
        }

        // GET: api/Event/5
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<ActionResult<EventResponse>> GetEvent(int id)
        {
            if (_context.Events == null)
            {
                return NotFound();
            }

            var data = await _context.Events
                            .Include(a => a.EventType)
                            .Include(a => a.Municipality)
                            .Include(a => a.Images)
                            .FirstOrDefaultAsync(a => a.Id == id);

            if (data == null)
            {
                return NotFound();
            }

            return Ok(new EventResponse
            {
                Id = data.Id,
                Title =data.Title,
                Description = data.Description,
                DateFrom = data.DateFrom,
                DateTo = data.DateTo,
                Active = data.Active,
                EventType = data.EventType,
                Municipality = data.Municipality,
                Images = data.Images
            });
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

            var type = await _context.EventTypes.FindAsync(request.TypeId);

            if (type == null)
            {
                return BadRequest("Type not found");
            }

            var @event = await _context.Events
            .Where(e => e.Id == id && e.UserId == userId)
            .SingleOrDefaultAsync();

            if (@event == null)
            {
                return NotFound();
            }

            @event.Title = request.Title;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EventExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/Event/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEvent(int id)
        {
            var @event = await _context.Events.FindAsync(id);
            if (@event == null)
            {
                return NotFound();
            }

            _context.Events.Remove(@event);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool EventExists(int id)
        {
            return _context.Events.Any(e => e.Id == id);
        }
    }
}
