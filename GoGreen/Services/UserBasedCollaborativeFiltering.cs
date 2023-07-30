namespace GoGreen.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using GoGreen.Data;
    using GoGreen.Models;
    using Microsoft.EntityFrameworkCore;

    public class UserBasedCollaborativeFiltering
    {
        private readonly ApplicationDbContext _context;

        public UserBasedCollaborativeFiltering(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Event>> GetRecommendedEventsForUserAsync(string userId)
        {

            // Step 1: Fetch events subscribed by the given user
            var subscribedEventIds = _context.EventSubscribes
                .Where(es => es.UserId == userId)
                .Select(es => es.EventId)
                .ToList();

            // Step 2: Fetch other users and their subscriptions
            var otherUsersSubscriptions = _context.EventSubscribes
                .Where(es => es.UserId != userId && subscribedEventIds.Contains(es.EventId))
                .GroupBy(es => es.UserId)
                .ToDictionary(g => g.Key, g => g.Select(es => es.EventId).ToList());

            // Step 3: Calculate Jaccard similarity between the given user and other users
            var userSimilarityScores = new Dictionary<string, double>();
            foreach (var (user, events) in otherUsersSubscriptions)
            {
                double intersectionCount = subscribedEventIds.Intersect(events).Count();
                double unionCount = subscribedEventIds.Union(events).Count();
                double jaccardSimilarity = intersectionCount / unionCount;
                userSimilarityScores[user] = jaccardSimilarity;
            }

            // Step 4: Select neighbors based on similarity scores
            var neighborUsers = userSimilarityScores
                .Where(kv => kv.Value > 0.1) // Choose neighbors with a similarity score threshold
                .Select(kv => kv.Key)
                .ToList();


            // Step 6: Fetch the recommended events from the database
            var recommendedEventIds = _context.EventSubscribes
                .Where(es => neighborUsers.Contains(es.UserId) && !subscribedEventIds.Contains(es.EventId))
                .GroupBy(es => es.EventId)
                .OrderByDescending(g => g.Count()) // Order by the number of times an event is subscribed by neighbors
                .Select(g => g.Key)
                .Take(10) // Get the top 10 recommended event IDs
                .ToList();

            // Step 7: Store the recommendations in the database
            var userRecommendations = new List<UserEventRecommendation>();

            foreach (var eventId in recommendedEventIds)
            {

                var recommendation = new UserEventRecommendation
                {
                    UserId = userId,
                    EventId = eventId
                };
                userRecommendations.Add(recommendation);
            }

            _context.UserEventRecommendations.AddRange(userRecommendations);
            _context.SaveChanges();

            // Step 8: Fetch the recommended events from the database
            var recommendedEvents = _context.Events
                .Where(e => recommendedEventIds.Contains(e.Id))
                .ToList();

            return recommendedEvents;
        }
    }

}
