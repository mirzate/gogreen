using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GoGreen.Models;
using GoGreen.Data;
using GoGreen.Responses;
using GoGreen.Requests;
using System.Security.Claims;
using System.Net;
using Microsoft.AspNetCore.Authorization;
using GoGreen.Services;
using AutoMapper;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class GreenIslandController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IGreenIslandService _greenIslandService;
        private readonly IMapper _mapper;

        public GreenIslandController(ApplicationDbContext context, IGreenIslandService greenIslandService, IMapper mapper)
        {
            _context = context;
            _greenIslandService = greenIslandService;
            _mapper = mapper;
        }

        // GET: api/GreenIsland
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<GreenIslandResponse>>> Index(int pageIndex = 1, int pageSize = 10)
        {

            var (datas, totalCount) = await _greenIslandService.Index(pageIndex, pageSize);

            return Ok(datas);

            var result = new GreenIslandPaginationResponse<GreenIslandResponse>
            {
                Items = (List<GreenIslandResponse>)datas,
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount
            };
            return Ok(result);

        }

        // GET: api/GreenIsland/5
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<ActionResult<GreenIslandResponse>> View(int id)
        {

            var data = await _greenIslandService.View(id);

            if (data == null)
            {
                return NotFound();
            }

            var dataResponse = _mapper.Map<GreenIslandResponse>(data);

            return Ok(dataResponse);

        }

        // POST: api/GreenIsland
        [HttpPost]
        public async Task<ActionResult<GreenIslandResponse>> Post([FromBody] GreenIslandRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var municipality = await _context.Municipalities.FindAsync(request.MunicipalityId);

            if (municipality == null)
            {
                return BadRequest($"The Municipality with ID {request.MunicipalityId} does not exist");
            }

            var data = _mapper.Map<GreenIslandRequest>(request);

            var createdData = await _greenIslandService.Store(data);

            return _mapper.Map<GreenIslandResponse>(createdData);

        }

        // PUT: api/GreenIsland/5
        [HttpPut("{id}")]
        public async Task<ActionResult<GreenIslandResponse>> Put(int id, [FromBody] GreenIslandRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var municipality = await _context.Municipalities.FindAsync(request.MunicipalityId);

            if (municipality == null)
            {
                return BadRequest($"The Municipality with ID {request.MunicipalityId} does not exist");
            }

            var updatedData = await _greenIslandService.Update(id, request);


            return _mapper.Map<GreenIslandResponse>(updatedData);
        }

        // DELETE: api/GreenIsland/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {

            var isDeleted = await _greenIslandService.Delete(id);

            if (!isDeleted)
            {
                return NotFound();
            }

            return NoContent();
        }

    }
}
