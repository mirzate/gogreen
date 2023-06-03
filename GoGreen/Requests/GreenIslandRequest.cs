using GoGreen.Models;
using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class GreenIslandRequest
    {
        [Required]
        public string Title { get; set; }
        [Required]
        public string Description { get; set; }
        [Required]
        public decimal Longitude { get; set; }
        [Required]
        public decimal Latitude { get; set; }
        [Required]
        public bool Active { get; set; }
        [Required]
        public int MunicipalityId { get; set; }

    }

}
