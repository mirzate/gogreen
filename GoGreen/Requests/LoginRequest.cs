using System.ComponentModel.DataAnnotations;

namespace GoGreen.Requests
{
    public class LoginRequest
    {
        [Required]
        public string? UserName { get; set; }
        [Required]
        public string? Password { get; set; }
    }

}
