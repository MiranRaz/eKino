using System;
namespace eKino.Model
{
    public partial class Movies
    {
        public int MovieId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Year { get; set; }
        public string RunningTime { get; set; }
        public byte[] Photo { get; set; }
        public int DirectorId { get; set; }
        public override string ToString()
        {
            return Title;
        }
        //public virtual Director Director { get; set; } = null!; 
        //public virtual ICollection<MovieGenre> MovieGenres { get; set; }
        //public virtual ICollection<Projection> Projections { get; set; }
        //public virtual ICollection<Rating> Ratings { get; set; }
    }
}

