using GoGreen.Models;

namespace GoGreen.Responses
{
    public class EcoViolationResponse
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Contact { get; set; }
        public string Response { get; set; }
        public bool Published { get; set; }

        //public EcoViolationStatus? EcoViolationStatus { get; set; }
        public EcoViolationStatusResponse EcoViolationStatus { get; set; }

        public List<ImageResponse> Images { get; set; }

        public ImageResponse FirstImage { get; set; }

    }

    public class EcoViolationStatusResponse
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }

}
