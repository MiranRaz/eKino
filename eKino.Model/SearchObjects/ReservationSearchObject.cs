using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.SearchObjects
{
    public class ReservationSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? ProjectionId { get; set; }
        public string? MovieTitle { get; set; }
        public DateTime? From { get; set; }
        public DateTime? To { get; set; }
    }
}
