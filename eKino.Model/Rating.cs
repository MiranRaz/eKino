using eKino.Model;
using System;
using System.Collections.Generic;

namespace eKino.Model
{
    public partial class Rating
    {
        public int RatingId { get; set; }
        public DateTime DateOfRating { get; set; }
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public int MovieId { get; set; }
        public virtual Movies Movie { get; set; }
        public int Value { get; set; }
    }
}
