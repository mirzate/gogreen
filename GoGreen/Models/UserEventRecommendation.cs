using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class UserEventRecommendation
    {
        public int Id { get; set; }

        [ForeignKey("User")]
        public string UserId { get; set; }
        public User User { get; set; }

        [ForeignKey("Event")]
        public int EventId { get; set; }
        public Event Event { get; set; }

    }
}
