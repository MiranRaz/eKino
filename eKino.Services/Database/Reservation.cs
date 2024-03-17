using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Reservation
    {
        public Reservation()
        {
            Transactions = new HashSet<Transaction>();
        }

        public int ReservationId { get; set; }
        public int UserId { get; set; }
        public int ProjectionId { get; set; }
        public DateTime? DateOfReservation { get; set; }
        public string? Row { get; set; }
        public string? Column { get; set; }
        //public string? Seat { get; set; }
        public string? NumTicket { get; set; }

        public virtual Projection Projection { get; set; } = null!;
        public virtual User User { get; set; } = null!;
        public virtual ICollection<Transaction> Transactions { get; set; }
    }
}
