using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Auditorium
    {
        public Auditorium()
        {
            Projections = new HashSet<Projection>();
        }

        public int AuditoriumId { get; set; }
        public string Name { get; set; } = null!;

        public virtual ICollection<Projection> Projections { get; set; }
    }
}
