using GoGreen.Responses;

namespace GoGreen.Responses
{
    internal class EcoViolationPaginationResponse<T>
    {
        public List<EcoViolationResponse> Items { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }
        public int TotalPages { get; set; }
    }
}