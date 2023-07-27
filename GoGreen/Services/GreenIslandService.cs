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
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace GoGreen.Services
{
    public class GreenIslandService : IGreenIslandService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public GreenIslandService(ApplicationDbContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<(IEnumerable<GreenIslandResponse> GreenIslands, int TotalCount)> Index(int pageIndex = 1, int pageSize = 10, string? fullTextSearch = "")
        {
      
            var query = _context.GreenIslands.AsQueryable();


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
                        .Include(a => a.GreenIslandImages)
                            .ThenInclude(ei => ei.Image)
                        .Include(e => e.Municipality)
                        .Take(pageSize)
                        .ToListAsync();
            
            //var dataResponses = _mapper.Map<IEnumerable<GreenIslandResponse>>(datas);

            var dataResponses = datas.Select(e =>
            {
                var dataResponses = _mapper.Map<GreenIslandResponse>(e);
                dataResponses.FirstImage = _mapper.Map<ImageResponse>(e.GreenIslandImages.FirstOrDefault()?.Image);
                return dataResponses;
            });

            return (dataResponses, totalCount);
        }
        public async Task<GreenIslandResponse> View(int id)
        {

            var data = await _context.GreenIslands
                .Include(a => a.GreenIslandImages)
                            .ThenInclude(ei => ei.Image)
                .FirstOrDefaultAsync(a => a.Id == id);

            if (data == null)
            {
                return null;
            }
            var dataResponse = _mapper.Map<GreenIslandResponse>(data);
            return dataResponse;
        }

        public async Task<GreenIsland> Store(GreenIslandRequest request)
        {
            
            var data = _mapper.Map<GreenIsland>(request);

            
            var userId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            var user = await _context.User.FirstOrDefaultAsync(a => a.Id == userId);

            data.MunicipalityId = (int)user.MunicipalityId;
            data.UserId = userId;

            _context.GreenIslands.Add(data);
            await _context.SaveChangesAsync();
            var dataCreated = _mapper.Map<GreenIsland>(data);
            return dataCreated;
        }

        public async Task<GreenIslandResponse> Update(int id, GreenIslandRequest request)
        {
            
            var userId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return null;
            }


            var existingData = await _context.GreenIslands
            .Where(e => e.Id == id)
            .SingleOrDefaultAsync();


            if (existingData == null)
            {
                return null;
            }


            existingData.Title = request.Title;

            existingData.Description = request.Description;

            existingData.Longitude = request.Longitude;

            existingData.Latitude = request.Latitude;
   
            existingData.Active = request.Active;

            _context.GreenIslands.Update(existingData);
            await _context.SaveChangesAsync();

            var updatedData = _mapper.Map<GreenIslandResponse>(existingData);

            return updatedData;
        }

        public async Task<bool> Delete(int id)
        {
            
            var userId = _httpContextAccessor.HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return false;
            }
            
            var dataToDelete = await _context.GreenIslands
            .Where(e => e.Id == id && e.UserId == userId)
            .SingleOrDefaultAsync();

            if (dataToDelete == null)
            {
                return false; 
            }

            _context.GreenIslands.Remove(dataToDelete);

            await _context.SaveChangesAsync();

            return true; 
        }



    }

}
