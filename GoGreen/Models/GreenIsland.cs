using GoGreen.Services;
using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class GreenIsland : IViewCountable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        
        [ForeignKey("Municipality")]
        public int MunicipalityId { get; set; }
        public Municipality Municipality { get; set; }

        public bool Active { get; set; }
        public decimal Longitude { get; set; }
        public decimal Latitude { get; set; }


        [ForeignKey("User")]
        public string UserId { get; set; }
        public User User { get; set; }

        public ICollection<GreenIslandImage> GreenIslandImages { get; set; }

        public int? ViewCount { get; set; } = 0;

    }


}
