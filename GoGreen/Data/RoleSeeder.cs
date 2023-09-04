using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Threading.Tasks;
using GoGreen.Models;
using Microsoft.EntityFrameworkCore;
using Bogus;


namespace GoGreen.Data
{
    public static class RoleSeeder
    {


        public static async Task SeedRoles(RoleManager<IdentityRole> roleManager, UserManager<User> userManager, IServiceProvider serviceProvider)
        {
            
            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();

           
            // Ensure the dbContext is not tracking any User entities
            foreach (var entry in dbContext.ChangeTracker.Entries<User>().ToList())
            {
                entry.State = EntityState.Detached;
            }

            var roleExists = await roleManager.RoleExistsAsync("super-admin");

            if (!roleExists)
            {
                await roleManager.CreateAsync(new IdentityRole("super-admin"));
            }

                try
                {
                    var admin = dbContext.Users.FirstOrDefault(a => a.Email == "admin@example.com");

                    if (admin != null)
                    {
                        await userManager.AddToRoleAsync(admin, "super-admin");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                }
            




        }


    }

}
