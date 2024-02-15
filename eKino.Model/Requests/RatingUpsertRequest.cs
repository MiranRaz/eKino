using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class RatingUpsertRequest
    {
        [Required]
        public int UserId { get; set; }
        [Required]
        public int MovieId { get; set; }
        [Required]
        [Range(minimum: 1, maximum: 5)]
        public int Value { get; set; }
    }
}
