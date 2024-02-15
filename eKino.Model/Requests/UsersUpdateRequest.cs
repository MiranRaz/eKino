using System;
using System.ComponentModel.DataAnnotations;

namespace eKino.Model.Requests
{
    public class UsersUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string FirstName { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string LastName { get; set; }

        [Required(AllowEmptyStrings = false)]
        [EmailAddress()]
        public string Email { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Phone { get; set; }

        [StringLength(50, MinimumLength = 4)]
        [Required(AllowEmptyStrings = false)]
        public string Username { get; set; }
        public string Password { get; set; }

        public string PasswordConfirm { get; set; }

        public bool? Status { get; set; }

        public List<int> RoleIdList { get; set; } = new List<int> { };
    }
}