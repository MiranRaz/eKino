using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class MovieUpsertRequest
    {

        [Required(AllowEmptyStrings = false)]
        public string Title { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Description { get; set; }
        [Required]
        public DateTime Year { get; set; }
        [Required]
        public string RunningTime { get; set; }
        public byte[]? Photo { get; set; }
        [Required]
        public int DirectorId { get; set; }
        public List<int>? MovieGenreIdList { get; set; } = new List<int> { };
    }
}
