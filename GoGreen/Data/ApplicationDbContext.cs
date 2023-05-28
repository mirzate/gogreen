
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using GoGreen.Models;

namespace GoGreen.Data
{
    public class ApplicationDbContext : IdentityDbContext<User>
    {

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<SimpleTable> SimpeTables { get; set; }
        public DbSet<User> User { get; set; }

        public DbSet<Municipality> Municipalities { get; set; }
        public DbSet<EventType> EventTypes { get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<EcoViolationStatus> EcoViolationStatuses { get; set; }
        public DbSet<EcoViolation> EcoViolations { get; set; }
        public DbSet<GreenIsland> GreenIslands { get; set; }
        public DbSet<Image> Images { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

        }

    }
}
