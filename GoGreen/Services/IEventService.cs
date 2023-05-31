using System.Collections.Generic;
using System.Drawing.Printing;
using System.Threading.Tasks;
using GoGreen.Requests;
using GoGreen.Models;
using GoGreen.Responses;
using Microsoft.AspNetCore.Mvc;

namespace GoGreen.Services
{
    public interface IEventService
    {

        Task<(IEnumerable<EventResponse> Events, int TotalCount)> GetAllAsync(int pageIndex, int pageSize);
        Task<EventResponse> GetById(int id);
        Task<Event> Create(EventRequest request);
        Task<EventResponse> Update(int id, EventRequest request);
        Task<bool> Delete(int id);

    }

}
