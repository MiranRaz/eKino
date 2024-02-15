using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.SearchObjects
{
    public class TransactionSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? ReservationId { get; set; }
        public DateTime? DateOfTransaction { get; set; }
    }
}
