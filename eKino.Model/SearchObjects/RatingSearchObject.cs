using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eKino.Model.SearchObjects
{
    public class RatingSearchObject : BaseSearchObject
    {
        public int UserId { get; set; }
        public int MovieId { get; set; }
    }
}
