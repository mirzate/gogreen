using System.Collections.Generic;
using System.Drawing.Printing;
using System.Threading.Tasks;
using GoGreen.Requests;
using GoGreen.Models;
using GoGreen.Responses;

namespace GoGreen.Services
{
    public interface IEventService
    {

        Task<(IEnumerable<EventResponse> Events, int TotalCount)> GetAllAsync(int pageIndex, int pageSize);
        Task<EventResponse> GetById(int id);
        Task<Event> Create(EventRequest request);
    }

}
