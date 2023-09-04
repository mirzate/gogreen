using GoGreen.Responses;

namespace GoGreen.Responses
{
    internal class UserPaginationResponse<T>
    {
        public List<UserResponse> Items { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }
        public int TotalPages { get; set; }
        

    }
}