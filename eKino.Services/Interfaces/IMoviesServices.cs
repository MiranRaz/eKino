using System;
using eKino.Model;

namespace eKino.Services.Interfaces
{
    public interface IMoviesServices
    {
        IList<Movies> Get();
    }
}

