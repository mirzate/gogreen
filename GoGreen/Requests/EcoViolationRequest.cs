using GoGreen.Models;
using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class EcoViolationRequest
    {
        [Required]
        public string Title { get; set; }
        [Required]
        public string Description { get; set; }
        [Required]
        public int MunicipalityId { get; set; }

        public string? Contact { get; set; } = null;
    }

}
