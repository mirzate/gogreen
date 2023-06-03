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
        
        public string Contact { get; set; }

        public string Response { get; set; }

    }

}
