﻿using Microsoft.AspNetCore.Mvc;
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
        private readonly IImageService _imageService;
        public GreenIslandController(ApplicationDbContext context, IGreenIslandService greenIslandService, IMapper mapper, IImageService imageService)
        {
            _context = context;
            _greenIslandService = greenIslandService;
            _mapper = mapper;
            _imageService=imageService;
        }

        // GET: api/GreenIsland
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<GreenIslandResponse>>> Index(int pageIndex = 1, int pageSize = 100, string? fullTextSearch = "")
        {

            var (datas, totalCount) = await _greenIslandService.Index(pageIndex, pageSize, fullTextSearch);
            var totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

            var result = new GreenIslandPaginationResponse<GreenIslandResponse>
            {
                Items = (List<GreenIslandResponse>)datas.ToList(),
                PageNumber = pageIndex,
                PageSize = pageSize,
                TotalCount = totalCount,
                TotalPages = totalPages
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
        [Authorize]
        [HttpPost]
        //[Consumes("multipart/form-data")]
        public async Task<ActionResult<GreenIslandResponse>> Post([FromBody] GreenIslandRequest request)
        {
            //, IFormFile imageFile

            var data = _mapper.Map<GreenIslandRequest>(request);

            var createdData = await _greenIslandService.Store(data);

            /*
            if (imageFile != null)
            {
                var image = await _imageService.SaveImage(imageFile);

                if (image != null)
                {
                    var eImage = new GreenIslandImage
                    {
                        GreenIslandId = createdData.Id,
                        ImageId = image.Id
                    };

                    _context.Add(eImage);

                    await _context.SaveChangesAsync();

                    createdData.GreenIslandImages.Add(eImage); // Add created Image object to new created object in step before

                }
            }
            */
            return _mapper.Map<GreenIslandResponse>(createdData);

        }

        // PUT: api/GreenIsland/5
        [Authorize]
        [HttpPut("{id}")]
        public async Task<ActionResult<GreenIslandResponse>> Put(int id, [FromBody] GreenIslandRequest request)
        {

            if (!await CheckPermisionAsync(id))
            {
                return BadRequest("The user has no permission for this action");
            }

            var updatedData = await _greenIslandService.Update(id, request);


            return _mapper.Map<GreenIslandResponse>(updatedData);
        }

        // DELETE: api/GreenIsland/5
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {

            if (!await CheckPermisionAsync(id))
            {
                return BadRequest("The user has no permission for this action");
            }

            var isDeleted = await _greenIslandService.Delete(id);

            if (!isDeleted)
            {
                return NotFound();
            }

            return NoContent();
        }

        [Authorize]
        [HttpPut("{greenIslandId}/Image")]
        [Consumes("multipart/form-data")]
        public async Task<ActionResult<GreenIslandResponse>> AddImage(int greenIslandId, IFormFile imageFile)

        {

            if (!await CheckPermisionAsync(greenIslandId))
            {
                return BadRequest("The user has no permission for this action");
            }

            var data = await _context.GreenIslands
                .Where(e => e.Id == greenIslandId)
                .Include(a => a.GreenIslandImages)
                    .ThenInclude(ei => ei.Image)
                .FirstOrDefaultAsync();

            if (data == null)
            {
                return NotFound();
            }

            if (imageFile != null)
            {
                var image = await _imageService.SaveImage(imageFile);

                if (image != null)
                {
                    var newImage = new GreenIslandImage
                    {
                        GreenIslandId = data.Id,
                        ImageId = image.Id
                    };

                    _context.Add(newImage);

                    await _context.SaveChangesAsync();

                    data.GreenIslandImages.Add(newImage); 

                }
            }

            return _mapper.Map<GreenIslandResponse>(data);


        }


        // DELETE: api/GreenIsland/5/Image/2
        [Authorize]
        [HttpDelete("{greenIslandId}/Image/{imageId}")]
        public async Task<IActionResult> DeleteEventImage(int greenIslandId, int imageId)
        {

            if (!await CheckPermisionAsync(greenIslandId))
            {
                return BadRequest("The user has no permission for this action");
            }

            var data = await _context.GreenIslands
                .Where(e => e.Id == greenIslandId)
                .Include(e => e.GreenIslandImages)
                    .ThenInclude(ei => ei.Image)
                .FirstOrDefaultAsync();

            if (data == null)
            {
                return NotFound();
            }

            var greenIslandImage = data.GreenIslandImages.FirstOrDefault(ei => ei.ImageId == imageId);

            if (greenIslandImage == null)
            {
                return NotFound();
            }

            data.GreenIslandImages.Remove(greenIslandImage);
            await _context.SaveChangesAsync();

            _imageService.DeleteImage(greenIslandImage.Image.FileName);


            return NoContent();
        }

        private async Task<bool> CheckPermisionAsync(int id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);


            if (string.IsNullOrEmpty(userId))
            {
                return false;
            }

            var user = await _context.User.Include(e => e.Municipality).FirstOrDefaultAsync(u => u.Id == userId);
            var data = await _context.GreenIslands
                        .Where(a => a.MunicipalityId == user.MunicipalityId)
                        .Where(a => a.Id == id)
                        .FirstOrDefaultAsync();

            if (data == null)
            {
                return false;
            }

            return true;

        }
    }
}
