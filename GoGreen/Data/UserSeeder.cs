using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading.Tasks;
using GoGreen.Models;
using Microsoft.EntityFrameworkCore;
using Bogus;


namespace GoGreen.Data
{
    public static class UserSeeder
    {
        public static async Task SeedUsers(UserManager<User> userManager, IServiceProvider serviceProvider)
        {
            // Check if any users already exist
            if (userManager.Users.Any())
            {
                return; // Data has already been seeded
            }

            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();
            var faker = new Bogus.Faker();

            var municipalities = dbContext.Municipalities.ToList();

            var users = new List<User>
            {
                new User
                {
                    UserName = "string",
                    Email = "string@example.com",
                    MunicipalityId = municipalities[faker.Random.Int(0, municipalities.Count - 1)].Id
                },
                new User
                {
                    UserName = "desktop",
                    Email = "desktop@example.com",
                    MunicipalityId = municipalities[faker.Random.Int(0, municipalities.Count - 1)].Id
                },
                new User
                {
                    UserName = "mobile",
                    Email = "mobile@example.com",
                    MunicipalityId = municipalities[faker.Random.Int(0, municipalities.Count - 1)].Id
                },
                new User
                {
                    UserName = "admin",
                    Email = "admin@example.com",
                    MunicipalityId = municipalities[faker.Random.Int(0, municipalities.Count - 1)].Id
                },
                new User
                {
                    UserName = "sarajevo",
                    Email = "sarajevo@example.com",
                    MunicipalityId = municipalities[faker.Random.Int(0, municipalities.Count - 1)].Id
                },

            };

            foreach (var user in users)
            {
                await userManager.CreateAsync(user, "test");
            }
     
        }


    }

}
