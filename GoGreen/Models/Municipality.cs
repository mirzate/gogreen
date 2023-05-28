namespace GoGreen.Models
{
    public class Municipality
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public bool Active { get; set; }

        //public string Logo { get; set; }

        public string Logo
        {
            get
            {
                if (Images?.Count > 0)
                {
                    return Images.First().FilePath; 
                }
                return null;
            }
            set
            {
                if (Images == null)
                {
                    Images = new List<Image>();
                }
                if (Images.Count > 0)
                {
                    Images.First().FilePath = value;
                }
                else
                {
                    Images.Add(new Image { FilePath = value }); 
                }
            }
        }

        public ICollection<Image> Images { get; set; }
        public ICollection<Event> Events { get; set; }
        public ICollection<GreenIsland> GreenIslands { get; set; }



    }

}
