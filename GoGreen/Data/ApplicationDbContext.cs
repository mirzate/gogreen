
using Microsoft.EntityFrameworkCore;
using GoGreen.Models;

namespace GoGreen.Data
{
    public class ApplicationDbContext : DbContext
    {

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        public DbSet<SimpleTable> SimpeTables { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {



        }

    }
}
