using AutoMapper;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;

namespace eKino.Services.Services
{
    public class GenreService : BaseCRUDService<Model.Genre, Database.Genre, GenreSearchObject, GenreUpsertRequest, GenreUpsertRequest>, IGenreService
    {
        public GenreService(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Genre> AddFilter(IQueryable<Database.Genre> query, GenreSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));
            }

            return filteredQuery;
        }

    }
}