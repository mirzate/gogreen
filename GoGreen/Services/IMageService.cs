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
    public class ImageService : IImageService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public ImageService(ApplicationDbContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor, IWebHostEnvironment webHostEnvironment)
        {
            _context = context;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<ImageResponse> SaveImage(IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
                return null;

            var uploadsFolderPath = Path.Combine(_webHostEnvironment.ContentRootPath, "uploads");
            if (!Directory.Exists(uploadsFolderPath))
                Directory.CreateDirectory(uploadsFolderPath);

            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(imageFile.FileName)}";
            var filePath = Path.Combine(uploadsFolderPath, fileName);

            using (var fileStream = new FileStream(filePath, FileMode.Create))
            {
                await imageFile.CopyToAsync(fileStream);
            }

            var image = new Image
            {
                FileName = fileName,
                FilePath = filePath
            };
            _context.Add(image);
            await _context.SaveChangesAsync();
            var createdImage = _mapper.Map<ImageResponse>(image);
            return createdImage;
        }

        public void DeleteImage(string fileName)
        {

            //WebRootPath
            var filePath = Path.Combine(_webHostEnvironment.ContentRootPath, "uploads", fileName);
            if (File.Exists(filePath))
                File.Delete(filePath);
        }

    }

}
