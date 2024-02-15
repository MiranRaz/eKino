using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.SearchObjects
{
    public class RoleSearchObject : BaseSearchObject
    {
        public int? RoleId { get; set; }
        public string? Name{ get; set; }
    }
}
