using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class EventTypeRequest
    {
        [Required]
        public string? Name { get; set; }

    }

}
