
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using GoGreen.Models;
using System.Net;
using Azure;
using Microsoft.Extensions.Hosting;

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
        public DbSet<EventImage> EventImages { get; set; }
        public DbSet<GreenIslandImage> GreenIslandImages { get; set; }

        public DbSet<EcoViolationImage> EcoViolationImages { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            // Event Model Image
            modelBuilder.Entity<EventImage>()
                .HasKey(ei => new { ei.EventId, ei.ImageId });

            modelBuilder.Entity<EventImage>()
                .HasOne(ei => ei.Event)
                .WithMany(e => e.EventImages)
                .HasForeignKey(ei => ei.EventId);

            modelBuilder.Entity<EventImage>()
                .HasOne(ei => ei.Image)
                .WithMany(i => i.EventImages)
                .HasForeignKey(ei => ei.ImageId);


            // EcoViolation Model Image
            modelBuilder.Entity<EcoViolationImage>()
                .HasKey(ei => new { ei.EcoViolationId, ei.ImageId });

            modelBuilder.Entity<EcoViolationImage>()
                .HasOne(ei => ei.EcoViolation)
                .WithMany(e => e.EcoViolationImages)
                .HasForeignKey(ei => ei.EcoViolationId);

            modelBuilder.Entity<EcoViolationImage>()
                .HasOne(ei => ei.Image)
                .WithMany(i => i.EcoViolationImages)
                .HasForeignKey(ei => ei.ImageId);

     

            // GreenIsland Model Image
            modelBuilder.Entity<GreenIslandImage>()
                .HasKey(ei => new { ei.GreenIslandId, ei.ImageId });

            modelBuilder.Entity<GreenIslandImage>()
                .HasOne(ei => ei.GreenIsland)
                .WithMany(e => e.GreenIslandImages)
                .HasForeignKey(ei => ei.GreenIslandId);

            modelBuilder.Entity<GreenIslandImage>()
                .HasOne(ei => ei.Image)
                .WithMany(i => i.GreenIslandImages)
                .HasForeignKey(ei => ei.ImageId);

            base.OnModelCreating(modelBuilder);
        }

    }
}
