using GoGreen.Data;
using GoGreen.Models;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Xml;
using Microsoft.AspNetCore.Identity;

namespace GoGreen.Data
{
    public class DataSeeder
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<User> _userManager;
        private readonly IServiceProvider _serviceProvider;
        public DataSeeder(ApplicationDbContext context, UserManager<User> userManager, IServiceProvider serviceProvider)
        {
            _context = context;
            _userManager = userManager;
            _serviceProvider=serviceProvider;
        }

        public async Task SeedData()
        {
            using (var scope = _serviceProvider.CreateScope())
            {

                /*
                // Check if any users already exist
                if (await _userManager.FindByEmailAsync("desktop") != null)
                {
                    // Users already seeded
                    return;
                }
                */
                _userManager.UserValidators.Clear();

                var users = new[]
                {
                    new User { UserName = "string", Email = "string@example.com" },
                    new User { UserName = "desktop", Email = "desktop@example.com" },
                    new User { UserName = "mobile", Email = "mobile@example.com" },
                    new User { UserName = "admin@example.com", Email = "admin@example.com" },
                    new User { UserName = "user5@example.com", Email = "user5@example.com" },
                    new User { UserName = "sarajevo", Email = "sarajevo@example.com" },
                };

                foreach (var user in users)
                {

                    if (await _userManager.FindByEmailAsync(user.Email) == null)
                    {
      
                        var result = await _userManager.CreateAsync(user, "test");

                        if (result.Succeeded)
                        {
                            Console.WriteLine($"User {user.Email} seeded successfully.");
                        }
                        else
                        {
                            Console.WriteLine($"Failed to seed user {user.Email}.");
                        }

                    }


                }

                Console.WriteLine("Data seeded successfully.");
            }
        }
    }
}
