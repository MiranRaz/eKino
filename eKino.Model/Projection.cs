using eKino.Model;
using System;
using System.Collections.Generic;

namespace eKino.Model
{
    public partial class Projection
    {
        public int ProjectionId { get; set; }
        public DateTime DateOfProjection { get; set; }
        public int AuditoriumId { get; set; }
        public virtual Auditorium Auditorium { get; set; }
        public int MovieId { get; set; }
        public virtual Movies Movie { get; set; }
        public decimal TicketPrice { get; set; }
        public override string ToString()
        {
            string s = "";
            if(Movie != null)
            {
                s = Movie.Title;
                if (s == "Any")
                    return s;
            }
            s += " - " + DateOfProjection.ToShortDateString() + " " + DateOfProjection.ToShortTimeString();
            return s;
        }
    }
}
