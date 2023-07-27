using GoGreen.Models;
using GoGreen.Requests;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Linq;
using System.Threading.Tasks;
using Bogus;
using Microsoft.Extensions.Logging;
using System.ComponentModel.DataAnnotations;

namespace GoGreen.Data
{
    public static class GreenIslandSeeder
    {
        public static async Task SeedGreenIslands(IServiceProvider serviceProvider)
        {
            // Retrieve the required services
            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();
            var userManager = serviceProvider.GetRequiredService<UserManager<User>>();

            // Check if any green islands already exist
            if (dbContext.GreenIslands.Any())
            {
                return; // Data has already been seeded
            }
            var municipalities = dbContext.Municipalities.ToList();

            if (municipalities is null)
            {
                throw new Exception("Municipality not found in the database."); // Handle the case where the municipality is not found
            }
            var faker = new Faker();

            var users = userManager.Users.ToList();

            var greenIslands = new List<GreenIslandRequest>();
            double minLongitude = 17.1; // Minimum longitude value for the region
            double maxLongitude = 17.9; // Maximum longitude value for the region

            double minLatitude = 43.1; // Minimum latitude value for the region
            double maxLatitude = 43.9; // Maximum latitude value for the region


            for (int i = 0; i < 1000; i++)
            {
                
                Random random = new Random();

                double longitude = random.NextDouble() * (maxLongitude - minLongitude) + minLongitude;
                double latitude = random.NextDouble() * (maxLatitude - minLatitude) + minLatitude;


                var municipality = municipalities[faker.Random.Int(0, municipalities.Count - 1)];
                var greenIslandRequest = new GreenIslandRequest
                {
                    Title = faker.Lorem.Sentence(),
                    Description = faker.Lorem.Paragraph(),
                    Longitude = (decimal)longitude,//faker.Address.Longitude(),
                    Latitude = (decimal)latitude,//faker.Address.Latitude(),
                    Active = true,// faker.Random.Bool(),
                    MunicipalityId = municipality.Id,
    
                };
                greenIslands.Add(greenIslandRequest);
            }

            foreach (var data in greenIslands)
            {
                var validationContext = new ValidationContext(data);
                Validator.ValidateObject(data, validationContext);
                var userId = users[faker.Random.Int(0, users.Count - 1)].Id;
                var @greenIsland = new GreenIsland
                {
                    Title = data.Title,
                    Description = data.Description,
                    Longitude = data.Longitude,
                    Latitude = data.Latitude,
                    Active = true,
                    MunicipalityId = (int)data.MunicipalityId,
                    UserId = userId
                };

                dbContext.Set<GreenIsland>().Add(@greenIsland);
            }

            dbContext.SaveChanges();


        }
    }
}
