using System;
namespace eKino.Model.SearchObjects
{
    public class DirectorSearchObject : BaseSearchObject
    {
        public string? Name { get; set; }
        // Full Text Search
        public string? FTS { get; set; }
    }
}

