using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Rating
    {
        public int RatingId { get; set; }
        public DateTime? DateOfRating { get; set; }
        public int UserId { get; set; }
        public int MovieId { get; set; }
        public int? Value { get; set; }

        public virtual Movie Movie { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
