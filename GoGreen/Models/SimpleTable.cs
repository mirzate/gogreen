using System.ComponentModel.DataAnnotations;

namespace GoGreen.Models
{
    public class SimpleTable
    {

        [Key]
        public int Id { get; set; }

        public string? Name { get; set; }

        public DateTime Datum { get; set; }

    }
}
