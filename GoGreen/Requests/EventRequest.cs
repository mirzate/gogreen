using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class EventRequest
    {
        [Required]
        public string? Title { get; set; }
        [Required]
        public string? Description { get; set; }
        [Required]
        public DateTime DateFrom { get; set; }
        [Required]
        public DateTime DateTo { get; set; }
        [Required]
        public bool Active { get; set; }
        [Required]
        public int TypeId { get; set; }

        public int? MunicipalityId { get; set; }
    }

}
