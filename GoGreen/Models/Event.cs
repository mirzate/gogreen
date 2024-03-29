﻿using Azure;
using GoGreen.Services;
using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class Event: IViewCountable
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }

        [ForeignKey("EventType")]
        public int TypeId { get; set; }
        public EventType EventType { get; set; }

        [ForeignKey("Municipality")]
        public int MunicipalityId { get; set; }
        public Municipality Municipality { get; set; }

        [ForeignKey("User")]
        public string UserId { get; set; }
        public User User { get; set; }

        public bool Active { get; set; }

        public ICollection<EventImage> EventImages { get; set; }

        public int? ViewCount { get; set; } = 0;

    }


}
