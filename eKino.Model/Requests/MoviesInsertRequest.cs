using System;
namespace eKino.Model.Requests
{
    public class MoviesInsertRequest
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Year { get; set; }
        public string RunningTime { get; set; }
        public byte[]? Photo { get; set; }
        public int DirectorId { get; set; }
    }
}

