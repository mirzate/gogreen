using System.Collections.Generic;
using System.Drawing.Printing;
using System.Threading.Tasks;
using GoGreen.Requests;
using GoGreen.Models;
using GoGreen.Responses;
using Microsoft.AspNetCore.Mvc;

namespace GoGreen.Services
{
    public interface IGreenIslandService
    {

        Task<(IEnumerable<GreenIslandResponse> GreenIslands, int TotalCount)> Index(int pageIndex, int pageSize, string? fullTextSearch);
        Task<GreenIslandResponse> View(int id);
        Task<GreenIsland> Store(GreenIslandRequest request);
        Task<GreenIslandResponse> Update(int id, GreenIslandRequest request);
        Task<bool> Delete(int id);

    }

}
