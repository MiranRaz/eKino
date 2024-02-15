using eKino.Model;
using System;
using System.Collections.Generic;

namespace eKino.Model
{
    public partial class Transaction 
    {
        public int TransactionId { get; set; }
        public DateTime DateOfTransaction { get; set; }
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public int ReservationId { get; set; }
        public virtual Reservation Reservation { get; set; }
        public decimal Amount { get; set; }
    }
}
