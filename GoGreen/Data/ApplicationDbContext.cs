﻿
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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

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


            base.OnModelCreating(modelBuilder);
        }

    }
}
