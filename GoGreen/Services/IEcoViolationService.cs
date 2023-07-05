using System.Collections.Generic;
using System.Drawing.Printing;
using System.Threading.Tasks;
using GoGreen.Requests;
using GoGreen.Models;
using GoGreen.Responses;
using Microsoft.AspNetCore.Mvc;

namespace GoGreen.Services
{
    public interface IEcoViolationService
    {

        Task<(IEnumerable<EcoViolationResponse> ecoViolations, int TotalCount)> Index(int pageIndex, int pageSize, string fullTextSearch);
        Task<EcoViolationResponse> View(int id);
        Task<EcoViolation> Store(EcoViolationRequest request);
        Task<EcoViolationResponse> Update(int id, EcoViolationRequest request);
        Task<bool> Delete(int id);

    }

}
