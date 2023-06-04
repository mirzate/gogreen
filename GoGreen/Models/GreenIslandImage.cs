using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class GreenIslandImage
    {
        public int GreenIslandId { get; set; }
        public GreenIsland GreenIsland { get; set; }

        public int ImageId { get; set; }
        public Image Image { get; set; }
    }
}

