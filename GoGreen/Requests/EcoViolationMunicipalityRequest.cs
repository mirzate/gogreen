using GoGreen.Models;
using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class EcoViolationMunicipalityRequest
    {
        [Required]
        public string Response { get; set; }
        [Required]
        public EcoViolationStatus EcoViolationStatus { get; set; }

    }

}
