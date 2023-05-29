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
            var eevent = await _context.Events.Include(o => o.User)
                .FirstOrDefaultAsync(o => o.Id == id);
            if (eevent == null)
            {
                return null;
            }
            var eventDto = _mapper.Map<EventResponse>(eevent);
            return eventDto;
        }

        public async Task<Event> Create(EventRequest eventDto)
        {
            var eevent = _mapper.Map<Event>(eventDto);
            eevent.UserId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            _context.Events.Add(eevent);
            await _context.SaveChangesAsync();
            var createdEventDto = _mapper.Map<Event>(eevent);
            return createdEventDto;
        }

    }

}
