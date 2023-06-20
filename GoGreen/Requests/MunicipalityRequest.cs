using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class MunicipalityRequest
    {
        [Required]
        public string? Title { get; set; }
        [Required]
        public string? Description { get; set; }
        [Required]
        public bool Active { get; set; }

    }

}
