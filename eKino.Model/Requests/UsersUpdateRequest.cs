using System;
namespace eKino.Model.Requests
{
    public class UsersUpdateRequest
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public bool? Status { get; set; }
    }
}