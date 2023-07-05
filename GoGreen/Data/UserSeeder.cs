using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading.Tasks;
using GoGreen.Models;


namespace GoGreen.Data
{
    public static class UserSeeder
    {
        public static async Task SeedUsers(UserManager<User> userManager)
        {
            // Check if any users already exist
            if (userManager.Users.Any())
            {
                return; // Data has already been seeded
            }

            var users = new List<User>
            {
                new User
                {
                    UserName = "string",
                    Email = "string@example.com"
                },
                new User
                {
                    UserName = "desktop",
                    Email = "desktop@example.com"
                },
                new User
                {
                    UserName = "mobile",
                    Email = "mobile@example.com"
                },
                new User
                {
                    UserName = "admin",
                    Email = "admin@example.com"
                },
                new User
                {
                    UserName = "sarajevo",
                    Email = "sarajevo@example.com"
                },

            };

            foreach (var user in users)
            {
                await userManager.CreateAsync(user, "test");
            }
     
        }


    }

}
