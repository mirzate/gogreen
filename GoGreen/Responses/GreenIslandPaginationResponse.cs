using GoGreen.Responses;

namespace GoGreen.Responses
{
    internal class GreenIslandPaginationResponse<T>
    {
        public List<GreenIslandResponse> Items { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }
    }
}