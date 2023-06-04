using Microsoft.Extensions.Hosting;
using System.ComponentModel.DataAnnotations.Schema;

namespace GoGreen.Models
{
    public class Image
    {
        public int Id { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }

        public ICollection<EventImage> EventImages { get; set; }
        public ICollection<GreenIslandImage> GreenIslandImages { get; set; }

    }

}
