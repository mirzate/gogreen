using GoGreen.Data;
using GoGreen.Responses;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class UserController : ControllerBase
    {

        private readonly ApplicationDbContext _dbContext;
        public UserController(ApplicationDbContext dbContext)
        {
            this._dbContext = dbContext;

        }

        //[Authorize]
        [HttpGet("/api/user")]
        public async Task<ActionResult<IEnumerable<UserResponse>>> GetUser()
        {

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            if (_dbContext.User == null)
            {
                return NotFound();
            }
            var user = await _dbContext.User.FirstOrDefaultAsync(u => u.Id == userId);

            var response = new UserResponse
            {
                Id = user.Id,
                Email = user.Email
            };

            return Ok(response);

        }



    }
}
