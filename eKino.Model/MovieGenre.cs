using System;
using System.Collections.Generic;

namespace eKino.Model
{
    public partial class MovieGenre
    {
        public int MovieGenreId { get; set; }
        public int MovieId { get; set; }
        public int GenreId { get; set; }
        public virtual Genre Genre { get; set; }
        public virtual Movies Movie { get; set; }
    }
}
