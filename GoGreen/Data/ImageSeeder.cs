using Bogus;
using Bogus.DataSets;   
using GoGreen.Models;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using RestSharp;
using Newtonsoft.Json.Linq;

namespace GoGreen.Data.Seeders
{
    public class ImageSeeder
    {
        public static async Task SeedImages(IServiceProvider serviceProvider)
        {
            var dbContext = serviceProvider.GetRequiredService<ApplicationDbContext>();

            if (dbContext is null)
            {
                throw new ArgumentNullException(nameof(dbContext));
            }

            var faker = new Faker();
            var images = new List<Image>();
            var events = dbContext.Events.ToList();
            var ecoViolations = dbContext.EcoViolations.ToList();
            var greenIslands = dbContext.GreenIslands.ToList();
            

            for (int i = 0; i < 100; i++){


                string imageUrl = GetRandomImageUrl();
                var rEvent = events[faker.Random.Int(0, events.Count - 1)];
                var rEcoViolation = ecoViolations[faker.Random.Int(0, ecoViolations.Count - 1)];
                var rGreenIsland = greenIslands[faker.Random.Int(0, greenIslands.Count - 1)];

                var image = new Image
                {
                    FileName = faker.System.FileName("jpg"),
                    FilePath = imageUrl,
                    EventImages = new List<EventImage>
                    {
                        new EventImage
                        {
                            EventId = rEvent.Id
                        }
                    },
                    GreenIslandImages = new List<GreenIslandImage>
                    {
                        new GreenIslandImage
                        {
                            GreenIslandId = rGreenIsland.Id
                        }
                    },
                    EcoViolationImages = new List<EcoViolationImage>
                    {
                        new EcoViolationImage
                        {
                            EcoViolationId = rEcoViolation.Id
                        }
                    }
                };

                images.Add(image);
                }

                dbContext.Images.AddRange(images);
                await dbContext.SaveChangesAsync();
            
        }
        public static string GetRandomImageUrl()
        {
            return "https://rs2storagegogreen.blob.core.windows.net/rs2containergogreen/gogreen.jpeg";
        }
    }

    

}
