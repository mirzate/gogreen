using GoGreen.Models;
using GoGreen.Requests;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace GoGreen.Data
{
    public static class EcoViolationStatusSeeder
    {
        public static async Task SeedEcoViolationStatuses(IServiceProvider serviceProvider)
        {
            // Retrieve the required services
            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();

            // Check if any eco violation statuses already exist
            if (dbContext.EcoViolationStatuses.Any())
            {
                return; // Data has already been seeded
            }

            var ecoViolationStatuses = new[]
            {
                new EcoViolationStatusRequest { Name = "Open" },
                new EcoViolationStatusRequest { Name = "In Progress" },
                new EcoViolationStatusRequest { Name = "Closed" }
            };

            // Create and add the eco violation statuses to the database
            foreach (var ecoViolationStatusRequest in ecoViolationStatuses)
            {
                var ecoViolationStatus = new EcoViolationStatus
                {
                    Name = ecoViolationStatusRequest.Name
                };

                dbContext.EcoViolationStatuses.Add(ecoViolationStatus);
            }

            // Save the changes to the database
            await dbContext.SaveChangesAsync();
        }
    }
}
