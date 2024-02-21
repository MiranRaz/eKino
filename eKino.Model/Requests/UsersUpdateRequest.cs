using System;
using System.ComponentModel.DataAnnotations;

namespace eKino.Model.Requests
{
    public class UsersUpdateRequest
    {
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Email { get; set; }
        public string? Phone { get; set; }

        public string? Username { get; set; }
        public string? Password { get; set; }

        public string? PasswordConfirm { get; set; }

        public bool Status { get; set; }

        public List<int> RoleIdList { get; set; } = new List<int> { };
    }
}