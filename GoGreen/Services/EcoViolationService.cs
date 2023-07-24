using System.Collections.Generic;
using System.Threading.Tasks;
using GoGreen.Data;
using GoGreen.Requests;
using GoGreen.Models;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using System.Security.Claims;
using GoGreen.Responses;
using Microsoft.AspNetCore.Mvc;

namespace GoGreen.Services
{
    public class EcoViolationService : IEcoViolationService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EcoViolationService(ApplicationDbContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<(IEnumerable<EcoViolationResponse> ecoViolations, int TotalCount)> Index(int pageIndex = 1, int pageSize = 10, string? fullTextSearch = "")
        {
     
            var query = _context.EcoViolations.AsQueryable();


            if (!string.IsNullOrEmpty(fullTextSearch))
            {
                query = query.Where(e => e.Title.Contains(fullTextSearch) || e.Description.Contains(fullTextSearch));
            }

            HttpContext httpContext = _httpContextAccessor.HttpContext;

            if (httpContext.User.Identity.IsAuthenticated)
            {
                var userId = httpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
                query = query.Where(e => e.UserId == userId);
            }

            var totalCount = await query.CountAsync();

            var datas = await query
                        .OrderByDescending(e => e.Id)
                        .Skip((pageIndex - 1) * pageSize)
                        .Include(e => e.EcoViolationImages)
                            .ThenInclude(ei => ei.Image)
                        .Include(e => e.Municipality)
                        .Include(e => e.EcoViolationStatus)
                        .Take(pageSize)
                        .ToListAsync();

            //var dataResponses = _mapper.Map<IEnumerable<EcoViolationResponse>>(datas);

            var dataResponses = datas.Select(e =>
            {
                var dataResponses = _mapper.Map<EcoViolationResponse>(e);
                dataResponses.FirstImage = _mapper.Map<ImageResponse>(e.EcoViolationImages.FirstOrDefault()?.Image);
                return dataResponses;
            });

            return (dataResponses, totalCount);

        }
        public async Task<EcoViolationResponse> View(int id)
        {

            var data = await _context.EcoViolations
                .Include(a => a.EcoViolationStatus)
                .Include(e => e.EcoViolationImages)
                            .ThenInclude(ei => ei.Image)
                .Include(e => e.Municipality)
                .FirstOrDefaultAsync(a => a.Id == id);

            if (data == null)
            {
                return null;
            }
            var dataResponse = _mapper.Map<EcoViolationResponse>(data);
            return dataResponse;
        }

        public async Task<EcoViolation> Store(EcoViolationRequest request)
        {
            
            var data = _mapper.Map<EcoViolation>(request);

            var openStatus = await _context.EcoViolationStatuses
                                        .FirstOrDefaultAsync(s => s.Name == "Open");

            if (openStatus != null)
            {

                data.EcoViolationStatusId = openStatus.Id;
            }

            _context.EcoViolations.Add(data);
            await _context.SaveChangesAsync();
            var dataCreated = _mapper.Map<EcoViolation>(data);
            return dataCreated;
        }

        public async Task<EcoViolationResponse> Update(int id, EcoViolationRequest request)
        {
            
            var userId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return null;
            }


            var existingData = await _context.EcoViolations
            .Where(e => e.Id == id)
            .SingleOrDefaultAsync();


            if (existingData == null)
            {
                return null;
            }

            // Update only the properties provided in the request
            if (request.Contact != null)
            {
                existingData.Contact = request.Contact;
            }


            // Update other properties as needed

            _context.EcoViolations.Update(existingData);
            await _context.SaveChangesAsync();

            var updatedData = _mapper.Map<EcoViolationResponse>(existingData);

            return updatedData;
        }

        public async Task<bool> Delete(int id)
        {
            /*
            var userId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return false;
            }
            */
            var dataToDelete = await _context.EcoViolations
            .Where(e => e.Id == id)
            .SingleOrDefaultAsync();

            if (dataToDelete == null)
            {
                return false; // Event not found
            }

            _context.EcoViolations.Remove(dataToDelete);

            await _context.SaveChangesAsync();

            return true; // Event successfully deleted
        }



    }

}
