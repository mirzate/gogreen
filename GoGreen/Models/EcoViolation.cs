using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class EcoViolation
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string? Contact { get; set; }
        public string? Response { get; set; }
        public bool? Published { get; set; } = true;


        public int? EcoViolationStatusId { get; set; } = 1;

        [ForeignKey("EcoViolationStatusId")]
        public EcoViolationStatus EcoViolationStatus { get; set; }

        public EcoViolationStatusEnum EcoViolationStatusEnum { get; set; }

        
        public string? UserId { get; set; }

        //[ForeignKey("UserId")]
        //public User User { get; set; }


        [ForeignKey("Municipality")]
        public int MunicipalityId { get; set; }
        public Municipality Municipality { get; set; }

        public ICollection<EcoViolationImage> EcoViolationImages { get; set; }

    }

    public enum EcoViolationStatusEnum
    {
        New,
        InProgress,
        Completed,
        Rejected
    }


}
