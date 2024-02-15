using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.SearchObjects
{
    public class ProjectionSearchObject : BaseSearchObject
    {
        public DateTime? DateOfProjection { get; set; }
        public int? AuditoriumId { get; set; }
        public int? MovieId { get; set; }
    }
}
