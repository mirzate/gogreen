namespace GoGreen.Services
{
    public interface IViewCountable
    {
        int? ViewCount { get; set; }
        public int Id { get; }
    }
}
