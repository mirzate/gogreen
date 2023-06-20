using System.Collections.Generic;
using System.Drawing.Printing;
using System.Threading.Tasks;
using GoGreen.Requests;
using GoGreen.Models;
using GoGreen.Responses;
using Microsoft.AspNetCore.Mvc;

namespace GoGreen.Services
{
    public interface IImageService
    {

        Task<ImageResponse> SaveImage(IFormFile imageFile);
        void DeleteImage(string fileName);

    }

}
