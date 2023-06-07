using GoGreen.Models;

namespace GoGreen.Responses
{
    public class EventResponse
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }
        public bool Active { get; set; }

        public EventType? EventType { get; set; }

        public Municipality? Municipality { get; set; }

        public List<ImageResponse> Images { get; set; }
        

    }


}
