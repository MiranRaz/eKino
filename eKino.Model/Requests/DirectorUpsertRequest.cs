using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class DirectorUpsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string FullName { get; set; }
        public string Biography { get; set; }
        public byte[]? Photo { get; set; }
    }
}
