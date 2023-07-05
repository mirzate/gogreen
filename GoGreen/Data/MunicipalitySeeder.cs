using GoGreen.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace GoGreen.Data.Seeders
{
    public static class MunicipalitySeeder
    {
        public static async Task SeedMunicipalities(ApplicationDbContext dbContext)
        {
            if (dbContext is null)
            {
                throw new ArgumentNullException(nameof(dbContext));
            }

            // Check if Municipalities already exist in the database
            if (dbContext.Municipalities.Any())
            {
                return; // Municipalities already seeded
            }

            // Create a list of test Municipalities
            var municipalities = new List<Municipality>
            {
                new Municipality { Title = "Sarajevo", Description = "Description 1", Active = true },
                new Municipality { Title = "Tuzla", Description = "Description 2", Active = true },
                new Municipality { Title = "Mostar", Description = "Description 3", Active = true },
                // Add more Municipalities here...
            };

            // Add the Municipalities to the database
            dbContext.Municipalities.AddRange(municipalities);
            dbContext.SaveChanges();
        }
    }
}
