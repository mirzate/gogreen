using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class EcoViolation
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Contact { get; set; }
        public string Response { get; set; }
        public bool Published { get; set; }

        [ForeignKey("EcoViolationStatus")]
        public string EcoViolationStatusId { get; set; }
        public EcoViolationStatus EcoViolationStatus { get; set; }

        public EcoViolationStatusEnum EcoViolationStatusEnum { get; set; }

        [ForeignKey("User")]
        public string UserId { get; set; }
        public User User { get; set; }

    }

    public enum EcoViolationStatusEnum
    {
        New,
        InProgress,
        Completed,
        Rejected
    }


}
