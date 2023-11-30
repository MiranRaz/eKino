using System;
using eKino.Model;
using eKino.Services.Interfaces;

namespace eKino.Services.Services
{
    public class MoviesServices : IMoviesServices
    {
        List<Movies> movies = new List<Movies>()
        {
            new Movies()
            {
                MovieId=1,
                Title="Test"
            }
        };
            
        public IList<Movies> Get()
        {
            return movies;
        }
    }
}

