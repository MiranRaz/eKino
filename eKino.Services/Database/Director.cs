using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Director
    {
        public Director()
        {
            Movies = new HashSet<Movie>();
        }

        public int DirectorId { get; set; }
        public string FullName { get; set; } = null!;
        public string Biography { get; set; } = null!;
        public byte[]? Photo { get; set; }

        public virtual ICollection<Movie> Movies { get; set; }
    }
}
