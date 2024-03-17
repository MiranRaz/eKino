using eKino.Model;
using System;
using System.Collections.Generic;

namespace eKino.Model
{
    public partial class Reservation 
    {
        public int ReservationId { get; set; }
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public int ProjectionId { get; set; }
        public virtual Projection Projection { get; set; }
        public DateTime DateOfReservation { get; set; }
        public string Row { get; set; }
        public string Column { get; set; }
        //public string Seat { get; set; }
        public string NumTicket { get; set; }
    }
}
