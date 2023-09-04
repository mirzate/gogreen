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

            var municipalitySarajevo = municipalities.FirstOrDefault(m => m.Title == "Sarajevo");
            var municipalityTuzla = municipalities.FirstOrDefault(m => m.Title == "Tuzla");
            var municipalityMostar = municipalities.FirstOrDefault(m => m.Title == "Mostar");


            var users = new List<User>
            {
                new User
                {
                    UserName = "admin",
                    Email = "admin@example.com",
                    MunicipalityId = municipalities[faker.Random.Int(0, municipalities.Count - 1)].Id,
                },
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
                    MunicipalityId = municipalitySarajevo.Id
                },
                new User
                {
                    UserName = "tuzla",
                    Email = "tuzla@example.com",
                    MunicipalityId = municipalityTuzla.Id
                },
                new User
                {
                    UserName = "mostar",
                    Email = "mostar@example.com",
                    MunicipalityId = municipalityMostar.Id
                },

            };

            foreach (var user in users)
            {
                await userManager.CreateAsync(user, "test");
               
            }

            var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();
            var roleExists = await roleManager.RoleExistsAsync("super-admin");

            if (!roleExists)
            {
                await roleManager.CreateAsync(new IdentityRole("super-admin"));
            }

            var userManagerI = serviceProvider.GetRequiredService<UserManager<IdentityUser>>();
            var userI = await userManagerI.FindByEmailAsync("admin@example.com");

            if (userI != null)
            {
                await userManagerI.AddToRoleAsync(userI, "super-admin");
            }


        }


    }

}
