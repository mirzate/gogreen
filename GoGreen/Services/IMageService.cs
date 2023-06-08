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
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace GoGreen.Services
{
    public class ImageService : IImageService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly IConfiguration _config;
        public ImageService(ApplicationDbContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor, IWebHostEnvironment webHostEnvironment, IConfiguration config)
        {
            _context = context;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
            _webHostEnvironment = webHostEnvironment;
            _config = config;
        }

        public async Task<ImageResponse> SaveImage(IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
                return null;


            // Cloud Azure Object Storage implementation
            var connectionString = _config["AzureStorage:ConnectionString"];
            var containerName = "rs2containergogreen";

            var blobServiceClient = new BlobServiceClient(connectionString);
            var containerClient = blobServiceClient.GetBlobContainerClient(containerName);

            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(imageFile.FileName)}";
            var blobClient = containerClient.GetBlobClient(fileName);

            using (var stream = imageFile.OpenReadStream())
            {
                await blobClient.UploadAsync(stream, overwrite: true);
            }

            var image = new Image
            {
                FileName = fileName,
                FilePath = blobClient.Uri.ToString()
            };

            /*
            // Local implementation
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
            */



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
