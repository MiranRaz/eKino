using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.Requests
{
    public class ProjectionUpsertRequest
    {
        [Required]
        public DateTime DateOfProjection { get; set; }
        [Required]
        public int AuditoriumId { get; set; }
        [Required]
        public int MovieId { get; set; }
        public decimal TicketPrice { get; set; }
    }
}
