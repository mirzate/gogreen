using Microsoft.AspNetCore.Identity;

namespace GoGreen.Models
{
    public class User : IdentityUser
    {
        // Dodatni atributi po zelji
        public int? MunicipalityId { get; set; }
        public Municipality Municipality { get; set; }
        public bool? isAdmin { get; set; } = false;
        public bool? isApproved { get; set; } = true;

    }
}
