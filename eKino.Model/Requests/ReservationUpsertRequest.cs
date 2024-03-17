using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class ReservationUpsertRequest
    {
        [Required]
        public int UserId { get; set; }
        [Required]
        public int ProjectionId { get; set; }
        [Required]
        public string Row { get; set; }
        [Required]
        public string Column { get; set; }
        //[Required]
        //public string Seat { get; set; }
        [Required]
        public string NumTicket { get; set; }
    }
}
