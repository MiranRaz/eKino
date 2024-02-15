using System;
namespace eKino.Model.SearchObjects
{
    public class DirectorSearchObject : BaseSearchObject
    {
        public string? FullName { get; set; }
        // Full Text Search
        public string? FTS { get; set; }
    }
}

