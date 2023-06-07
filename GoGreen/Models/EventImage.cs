using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class EventImage
    {
        public int EventId { get; set; }
        public Event Event { get; set; }

        public int ImageId { get; set; }
        public Image Image { get; set; }
    }
}

