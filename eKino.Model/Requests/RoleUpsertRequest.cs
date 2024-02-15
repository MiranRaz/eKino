using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class RoleUpsertRequest
    {
        public int RoleId { get; set; }
        public string? Name { get; set; }
    }
}
