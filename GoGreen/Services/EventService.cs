using System.Collections.Generic;
using System.Threading.Tasks;
using GoGreen.Data;
using GoGreen.Requests;
using GoGreen.Models;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using System.Security.Claims;
using GoGreen.Responses;

namespace GoGreen.Services
{
    public class EventService : IEventService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EventService(ApplicationDbContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<(IEnumerable<EventResponse> Events, int TotalCount)> GetAllAsync(int pageIndex = 1, int pageSize = 10)
        {
            var query = _context.Events;

            var totalCount = await query.CountAsync();

            var events = await query.Skip((pageIndex - 1) * pageSize)
                        .Take(pageSize)
                        .ToListAsync();
            
            var eventResponses = _mapper.Map<IEnumerable<EventResponse>>(events);

            return (eventResponses, totalCount);
        }
        public async Task<EventResponse> GetById(int id)
        {

            var data = await _context.Events
                .Include(a => a.EventType)
                .Include(a => a.Municipality)
                .Include(a => a.Images)
                .FirstOrDefaultAsync(a => a.Id == id);

            if (data == null)
            {
                return null;
            }
            var eventResponse = _mapper.Map<EventResponse>(data);
            return eventResponse;
        }

        public async Task<Event> Create(EventRequest eventRequest)
        {
            
            var data = _mapper.Map<Event>(eventRequest);

            data.UserId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            _context.Events.Add(data);
            await _context.SaveChangesAsync();
            var createdEvent = _mapper.Map<Event>(data);
            return createdEvent;
        }

    }

}
