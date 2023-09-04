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
        private readonly IImageService _imageService;

        public EcoViolationController(ApplicationDbContext context, IEcoViolationService ecoViolationService, IMapper mapper, IImageService imageService)
        {
            _context = context;
            _ecoViolationService = ecoViolationService;
            _mapper = mapper;
            _imageService=imageService;
        }

        // GET: api/EcoViolation
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EcoViolationResponse>>> Index(int pageIndex = 1, int pageSize = 10, string? fullTextSearch = "")
        {

            var (datas, totalCount) = await _ecoViolationService.Index(pageIndex, pageSize, fullTextSearch);


            var totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

            var result = new EcoViolationPaginationResponse<EcoViolationResponse>
            {
                Items = (List<EcoViolationResponse>)datas.ToList(),
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount,
                TotalPages = totalPages
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
        [AllowAnonymous]
        [HttpPost]
        [Consumes("multipart/form-data")]
        public async Task<ActionResult<EcoViolationResponse>> Post([FromForm] EcoViolationRequest request, List<IFormFile?> imageFiles)
        {

            var data = _mapper.Map<EcoViolationRequest>(request);

            var createdData = await _ecoViolationService.Store(data);

            if (imageFiles != null && imageFiles.Count > 0)
            {
                foreach (var imageFile in imageFiles)
                {
                    var image = await _imageService.SaveImage(imageFile);

                    if (image != null)
                    {
                        var nImage = new EcoViolationImage
                        {
                            EcoViolationId = createdData.Id,
                            ImageId = image.Id
                        };

                        _context.Add(nImage);

                        await _context.SaveChangesAsync();

                        createdData.EcoViolationImages.Add(nImage);
                    }
                }
            }

            return _mapper.Map<EcoViolationResponse>(createdData);

        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<ActionResult<EcoViolationResponse>> Put(int id, [FromBody] EcoViolationMunicipalityRequest request)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrEmpty(userId))
            {
                return BadRequest("The user ID claim is missing");
            }

            var type = await _context.EcoViolationStatuses.FindAsync(request.EcoViolationStatus.Id);

            if (type == null)
            {
                return BadRequest("Eco Violation Status not found");
            }

            var user = await _context.User.Include(e => e.Municipality).FirstOrDefaultAsync(u => u.Id == userId);


            var data = await _context.EcoViolations
                        .Where(a => a.MunicipalityId == user.MunicipalityId)
                        .Where(a => a.Id == id)
                        .FirstOrDefaultAsync();

            if (data == null)
            {
                return BadRequest("The user has no permission for this action");
            }

            var updatedData = await _ecoViolationService.Update(id, request);


            return _mapper.Map<EcoViolationResponse>(updatedData);
        }


        // DELETE: api/EcoViolation/5
        [Authorize]
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
