using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class GenreUpsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Name { get; set; }
    }
}
