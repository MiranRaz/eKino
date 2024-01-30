using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Projection
    {
        public Projection()
        {
            Reservations = new HashSet<Reservation>();
        }

        public int ProjectionId { get; set; }
        public DateTime? DateOfProjection { get; set; }
        public int AuditoriumId { get; set; }
        public int MovieId { get; set; }
        public decimal? TicketPrice { get; set; }

        public virtual Auditorium Auditorium { get; set; } = null!;
        public virtual Movie Movie { get; set; } = null!;
        public virtual ICollection<Reservation> Reservations { get; set; }
    }
}
