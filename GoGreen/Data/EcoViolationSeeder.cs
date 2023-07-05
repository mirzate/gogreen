using GoGreen.Models;
using GoGreen.Requests;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace GoGreen.Data
{
    public static class EcoViolationSeeder
    {
        public static async Task SeedEcoViolations(IServiceProvider serviceProvider)
        {
            // Retrieve the required services
            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();
            var faker = new Bogus.Faker();

            // Check if any eco violations already exist
            if (dbContext.EcoViolations.Any())
            {
                return; // Data has already been seeded
            }

            // Retrieve a list of municipalities
            var municipalities = dbContext.Municipalities.ToList();

            var ecoViolations = new List<EcoViolation>();

            for (int i = 0; i < 100; i++)
            {
                var municipality = municipalities[faker.Random.Int(0, municipalities.Count - 1)];

                var ecoViolationRequest = new EcoViolationRequest
                {
                    Title = faker.Lorem.Sentence(),
                    Description = faker.Lorem.Paragraph(),
                    MunicipalityId = municipality.Id,
                    Contact = faker.Phone.PhoneNumber()
                };

                var ecoViolation = new EcoViolation
                {
                    Title = ecoViolationRequest.Title,
                    Description = ecoViolationRequest.Description,
                    MunicipalityId = ecoViolationRequest.MunicipalityId,
                    Contact = ecoViolationRequest.Contact
                };

                ecoViolations.Add(ecoViolation);
            }

            // Add the eco violations to the database
            dbContext.EcoViolations.AddRange(ecoViolations);

            // Save the changes to the database
            await dbContext.SaveChangesAsync();
        }
    }
}
