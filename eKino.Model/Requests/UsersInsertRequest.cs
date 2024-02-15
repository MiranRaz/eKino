using System;
using System.ComponentModel.DataAnnotations;

namespace eKino.Model.Requests
{
    public class UsersInsertRequest
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "First Name is required!")]
        public string FirstName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Last Name is required!")]
        public string LastName { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Username is required!")]
        public string Username { get; set; }
        public bool? Status { get; set; }
        [Required(AllowEmptyStrings = false)]
        [EmailAddress()]
        public string Email { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Phone { get; set; }

        [Compare("PasswordConfirmation", ErrorMessage ="Passwords do not match")]
        public string Password { get; set; }

        [Compare("Password", ErrorMessage = "Passwords do not match")]
        public string PasswordConfirmation { get; set; }

        public List<int> RoleIdList { get; set; } = new List<int> { };
    }
}

