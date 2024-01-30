using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class Transaction
    {
        public int TransactionId { get; set; }
        public DateTime? DateOfTransaction { get; set; }
        public int UserId { get; set; }
        public int ReservationId { get; set; }
        public decimal? Amount { get; set; }

        public virtual Reservation Reservation { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
