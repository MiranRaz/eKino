using System;
namespace eKino.Model.SearchObjects
{
    public class MoviesSearchObject : BaseSearchObject
    {
        public string? FTS { get; set; }
        public string? Title { get; set; }
    }
}

