using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class EcoViolationImage
    {
        public int EcoViolationId { get; set; }
        public EcoViolation EcoViolation { get; set; }

        public int ImageId { get; set; }
        public Image Image { get; set; }
    }
}

