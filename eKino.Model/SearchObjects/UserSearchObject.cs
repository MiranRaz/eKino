using System;
namespace eKino.Model.SearchObjects
{
    public class UserSearchObject : BaseSearchObject
    {
        public string? Username { get; set; }

        public string? Email { get; set; }

        public string? Name { get; set; }

        public bool? IsRoleIncluded { get; set; }
    }
}
 