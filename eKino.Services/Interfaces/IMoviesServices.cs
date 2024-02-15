using System;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;

namespace eKino.Services.Interfaces
{
    public interface IMoviesServices : ICRUDService<Model.Movies, MoviesSearchObject, MovieUpsertRequest, MovieUpsertRequest>
    {
        List<Model.Movies> Recommend(int id);
    }
}
