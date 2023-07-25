﻿
using GoGreen.Models;

namespace GoGreen.Responses
{
    public class UserResponse
    {
        public string Id { get; set; }
        public string? Email { get; set; }
        public Municipality? Municipality { get; set; }
    }
}
