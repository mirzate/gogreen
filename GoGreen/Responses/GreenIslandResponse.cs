using GoGreen.Models;

namespace GoGreen.Responses
{
    public class GreenIslandResponse
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public decimal Longitude { get; set; }
        public decimal Latitude { get; set; }
        public Municipality? Municipality { get; set; }
        public bool Active { get; set; }

    }

}
