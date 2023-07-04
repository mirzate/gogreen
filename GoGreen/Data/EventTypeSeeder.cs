using GoGreen.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace GoGreen.Data.Seeders
{
    public static class EventTypeSeeder
    {
        public static async Task SeedEventTypes(ApplicationDbContext dbContext)
        {
            if (dbContext is null)
            {
                throw new ArgumentNullException(nameof(dbContext));
            }

            // Check if EventTypes already exist in the database
            if (dbContext.EventTypes.Any())
            {
                return; // EventTypes already seeded
            }

            // Create a list of test EventTypes
            var eventTypes = new List<EventType>
            {
                new EventType { Name = "Eco dani" },
                new EventType { Name = "Akcija ciscenja" },
                new EventType { Name = "Edukacija" },
                // Add more EventTypes here...
            };

            // Add the EventTypes to the database
            dbContext.EventTypes.AddRange(eventTypes);
            dbContext.SaveChanges();
        }
    }
}
