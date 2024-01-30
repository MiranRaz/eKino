using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Movie
    {
        public Movie()
        {
            MovieGenres = new HashSet<MovieGenre>();
            Projections = new HashSet<Projection>();
            Ratings = new HashSet<Rating>();
        }

        public int MovieId { get; set; }
        public string Title { get; set; } = null!;
        public string Description { get; set; } = null!;
        public DateTime Year { get; set; }
        public string RunningTime { get; set; } = null!;
        public byte[]? Photo { get; set; }
        public int DirectorId { get; set; }

        public virtual Director Director { get; set; } = null!;
        public virtual ICollection<MovieGenre> MovieGenres { get; set; }
        public virtual ICollection<Projection> Projections { get; set; }
        public virtual ICollection<Rating> Ratings { get; set; }
    }
}
