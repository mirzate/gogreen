using AutoMapper;
using Bogus.DataSets;
using GoGreen.Data;
using GoGreen.Models;
using GoGreen.Responses;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Drawing.Printing;
using System.Security.Claims;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class UserController : ControllerBase
    {

        private readonly ApplicationDbContext _dbContext;
        private readonly IMapper _mapper;
        public UserController(ApplicationDbContext dbContext, IMapper mapper)
        {
            this._dbContext = dbContext;
            _mapper = mapper;

        }

        [Authorize]
        [HttpGet("/api/user")]
        public async Task<ActionResult<IEnumerable<UserResponse>>> GetUser()
        {
            
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }
            
            var user = await _dbContext.Users
                .Include(e => e.Municipality)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null)
            {
                return NotFound();
            }
        
            var roles = User.FindAll(ClaimTypes.Role).Select(c => c.Value).ToList();

            var response = _mapper.Map<UserResponse>(user);

            response.Roles = roles;

            return Ok(response);

        }
        [Authorize(Roles = "super-admin")]
        [HttpGet("/api/users")]
        public async Task<ActionResult<IEnumerable<UserResponse>>> GetUsers(int pageIndex = 1, int pageSize = 20, string? fullTextSearch = "")
        {

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var query = _dbContext.Users
                .Include(e => e.Municipality)
                .Where(a => a.Id != userId);

            if (!string.IsNullOrWhiteSpace(fullTextSearch))
            {
                query = query.Where(u => u.Email.Contains(fullTextSearch) ||
                    u.Id.Contains(fullTextSearch) ||
                    u.Municipality.Title.Contains(fullTextSearch));
            }

            var totalCount = await query.CountAsync();
            var users = await query
                .Skip((pageIndex - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var userResponses = _mapper.Map<IEnumerable<UserResponse>>(users);

            var result = new UserPaginationResponse<UserResponse>
            {
                Items = (List<UserResponse>)userResponses,
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount,
                TotalPages = (int)Math.Ceiling((double)totalCount / pageSize)
            };
            return Ok(result);

        }

        [Authorize(Roles = "super-admin")]
        [HttpPut("/api/users/{id}/approve")]
        public async Task<IActionResult> setApprove(String id, bool isApproved)
        {

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var user = await _dbContext.Users
                .Where(u => u.Id == id)
                .Where(a => a.Id != userId)
                .SingleOrDefaultAsync();

            if (user == null)
            {
                return NotFound();
            }

            user.isApproved = isApproved;
            await _dbContext.SaveChangesAsync();
 
            return Ok();

        }

        [Authorize(Roles = "super-admin")]
        [HttpPut("/api/users/{id}/municipality/{municipality_id}")]
        public async Task<IActionResult> updateMunicipality(String id, int municipality_id)
        {

            var user = await _dbContext.Users
                .Where(u => u.Id == id)
                .Where(a => a.MunicipalityId != municipality_id)
                .SingleOrDefaultAsync();

            if (user == null)
            {
                return NotFound();
            }

            user.MunicipalityId = municipality_id;
            await _dbContext.SaveChangesAsync();

            return Ok();

        }

    }
}
