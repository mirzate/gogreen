
using Microsoft.AspNetCore.Mvc;
using GoGreen.Data;
using GoGreen.Services;
using Microsoft.AspNetCore.Authorization;
using GoGreen.Requests;


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

            return Ok(response);
        }

        [AllowAnonymous]
        [HttpPost("/api/auth/register")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(string))]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            var response = new { access_token = await _authenticationService.Register(request) };


            return Ok(response);
        }
        
    }
}
