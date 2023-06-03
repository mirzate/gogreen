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
    public class EcoViolationController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly IEcoViolationService _ecoViolationService;
        private readonly IMapper _mapper;

        public EcoViolationController(ApplicationDbContext context, IEcoViolationService ecoViolationService, IMapper mapper)
        {
            _context = context;
            _ecoViolationService = ecoViolationService;
            _mapper = mapper;
        }

        // GET: api/EcoViolation
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EcoViolationResponse>>> Index(int pageIndex = 1, int pageSize = 10)
        {

            var (datas, totalCount) = await _ecoViolationService.Index(pageIndex, pageSize);

            return Ok(datas);

            var result = new EcoViolationPaginationResponse<EcoViolationResponse>
            {
                Items = (List<EcoViolationResponse>)datas,
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount
            };
            return Ok(result);

        }

        // GET: api/EcoViolation/5
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<ActionResult<EcoViolationResponse>> View(int id)
        {

            var data = await _ecoViolationService.View(id);

            if (data == null)
            {
                return NotFound();
            }

            var dataResponse = _mapper.Map<EcoViolationResponse>(data);

            return Ok(dataResponse);

        }

        // POST: api/EcoViolation
        [HttpPost]
        public async Task<ActionResult<EcoViolationResponse>> Post([FromBody] EcoViolationRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }


            var data = _mapper.Map<EcoViolationRequest>(request);

            var createdData = await _ecoViolationService.Store(data);

            return _mapper.Map<EcoViolationResponse>(createdData);

        }

        // PUT: api/EcoViolation/5
        [HttpPut("{id}")]
        public async Task<ActionResult<EcoViolationResponse>> Put(int id, [FromBody] EcoViolationRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var updatedData = await _ecoViolationService.Update(id, request);


            return _mapper.Map<EcoViolationResponse>(updatedData);
        }

        // DELETE: api/EcoViolation/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {

            var isDeleted = await _ecoViolationService.Delete(id);

            if (!isDeleted)
            {
                return NotFound();
            }

            return NoContent();
        }

    }
}
