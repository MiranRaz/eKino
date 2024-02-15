using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class TransactionUpsertRequest
    {
        public DateTime DateOfTransaction { get; set; }
        public int UserId { get; set; }
        public int ReservationId { get; set; }
        public decimal Amount { get; set; }
    }
}
