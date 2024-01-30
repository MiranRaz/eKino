using System;
using AutoMapper;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;

namespace eKino.Services.Services
{
    public class MoviesServices : BaseCRUDService<Model.Movies, Database.Movie, MoviesSearchObject, MoviesInsertRequest, MoviesUpdateRequest>, IMoviesServices
    {
        public MoviesServices(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Movie> AddFilter(IQueryable<Movie> query, MoviesSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Title.Contains(search.FTS) || x.Description.Contains(search.FTS));
            }

            if (!string.IsNullOrWhiteSpace(search.Title))
            {
                filteredQuery = filteredQuery.Where(x => x.Title == search.Title);
            }

            return filteredQuery;
        }

    }
}

