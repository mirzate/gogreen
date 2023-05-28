namespace GoGreen.Models
{
    public class EcoViolationStatus
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public ICollection<EcoViolation> EcoViolations { get; set; }
    }

}
