
using Microsoft.AspNetCore.Mvc;
using GoGreen.Data;
using GoGreen.Services;
using Microsoft.AspNetCore.Authorization;
using GoGreen.Requests;
using System.Security.Claims;
using GoGreen.Models;
using Azure.Core;
using Microsoft.IdentityModel.Tokens;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly ApplicationDbContext _dbContext;
        private readonly IAuthenticationService _authenticationService;

        public AuthenticationController(IConfiguration config, ApplicationDbContext dbContext, IAuthenticationService authenticationService)
        {
            _config = config;
            this._dbContext = dbContext;
            _authenticationService=authenticationService;
        }


     
        [AllowAnonymous]
        [HttpPost("/api/auth/login")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(string))]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {

            var response = new { access_token = await _authenticationService.Login(request) };

            /*
            var access_token = await _authenticationService.Login(request);

            var user = HttpContext.User;
            var isAdminClaim = user.FindFirst("IsAdmin");
            var isApprovedClaim = user.FindFirst("IsApproved");

            var response = new LoginInfo
            {
                access_token = access_token,
                isAdmin = isAdminClaim != null && bool.TryParse(isAdminClaim.Value, out var isAdminValue) && isAdminValue,
                isApproved = isApprovedClaim != null && bool.TryParse(isApprovedClaim.Value, out var isApprovedValue) && isApprovedValue
            };
            */
            return Ok(response);

        }
        public class LoginInfo
        {
            public string access_token { get; set; }
            public bool isAdmin { get; set; }
            public bool? isApproved { get; set; }
        }

        [AllowAnonymous]
        [HttpPost("/api/auth/register")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(string))]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            try
            {
                var accessToken = await _authenticationService.Register(request);
                return Ok(new { access_token = accessToken });
            }
            catch (ArgumentException ex)
            {
                return Conflict(new { message = ex.Message });
            }
        }
        
    }
}
