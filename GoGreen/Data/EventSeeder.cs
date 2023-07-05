using GoGreen.Requests;
using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using GoGreen.Data;
using GoGreen.Models;
using Bogus;

namespace GoGreen.Data
{
    public static class EventSeeder
    {
        public static async Task SeedEvents(IServiceProvider serviceProvider)
        {
            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();

            if (dbContext is null)
            {
                throw new ArgumentNullException(nameof(dbContext));
            }

            // Check if events already exist in the database
            if (dbContext.Set<Event>().Any())
            {
                return; // Events already seeded
            }

            // Fetch a user from the database
            var user = dbContext.Set<User>().FirstOrDefault();

            if (user is null)
            {
                throw new Exception("No user found in the database."); // Handle the case where no user exists
            }

            // Fetch the municipality with the title "Sarajevo" from the database
            //var municipality = dbContext.Set<Municipality>().FirstOrDefault(m => m.Title == "Sarajevo");
            var municipalities = dbContext.Municipalities.ToList();

            if (municipalities is null)
            {
                throw new Exception("Municipality not found in the database."); // Handle the case where the municipality is not found
            }

            var eventTypes = dbContext.EventTypes.ToList();

            if (eventTypes is null)
            {
                throw new Exception("EventType not found in the database."); // Handle the case where the municipality is not found
            }

            var faker = new Faker();

            var events = new List<EventRequest>();

            for (int i = 0; i < 200; i++)
            {
                //EventType randomEventType = GetRandomEventType(dbContext);
                var randomEventType = eventTypes[faker.Random.Int(0, eventTypes.Count - 1)];
                var municipality = municipalities[faker.Random.Int(0, municipalities.Count - 1)];

                var eventRequest = new EventRequest
                {
                    Title = faker.Lorem.Sentence(),
                    Description = faker.Lorem.Paragraph(),
                    DateFrom = DateTime.Now.AddDays(1),
                    DateTo = DateTime.Now.AddDays(2),
                    Active = true,
                    TypeId = randomEventType.Id,
                    MunicipalityId = municipality.Id
                };
                events.Add(eventRequest);

            }
         
            // Validate and add the events to the database
            foreach (var eventData in events)
            {
                var validationContext = new ValidationContext(eventData);
                Validator.ValidateObject(eventData, validationContext);

                var @event = new Event
                {
                    Title = eventData.Title,
                    Description = eventData.Description,
                    DateFrom = eventData.DateFrom,
                    DateTo = eventData.DateTo,
                    Active = eventData.Active,
                    TypeId = eventData.TypeId,
                    MunicipalityId = eventData.MunicipalityId,
                    UserId = user.Id
                };

                dbContext.Set<Event>().Add(@event);
            }

            dbContext.SaveChanges();
           
        }

        public static EventType GetRandomEventType(DbContext dbContext)
        {
            if (dbContext is null)
            {
                throw new ArgumentNullException(nameof(dbContext));
            }

            // Fetch all EventTypes from the database
            var eventTypes = dbContext.Set<EventType>().ToList();

            if (!eventTypes.Any())
            {
                throw new Exception("No EventTypes found in the database."); // Handle the case where no EventTypes are available
            }

            // Generate a random index within the range of the eventTypes list
            var randomIndex = new Random().Next(eventTypes.Count);

            // Return the randomly selected EventType
            return eventTypes[randomIndex];
        }


    }

}
