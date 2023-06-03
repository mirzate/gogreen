using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class EcoViolationStatusRequest
    {
        [Required]
        public string? Name { get; set; }

    }

}
