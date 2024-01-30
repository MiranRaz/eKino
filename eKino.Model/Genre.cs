using System;
using System.Collections.Generic;

namespace eKino.Model
{
    public partial class Genre
    {
        public int GenreId { get; set; }
        public string Name { get; set; } = null!;

        public override string ToString()
        {
            return Name;
        }
    }
}
