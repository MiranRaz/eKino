using AutoMapper;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using eKino.Model;
using eKino.Services.Interfaces;

namespace eKino.Services.Services
{
    public class RatingService : BaseCRUDService<Model.Rating, Database.Rating, RatingSearchObject, RatingUpsertRequest, RatingUpsertRequest>, IRatingService
    {
        public RatingService(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Rating> AddFilter(IQueryable<Database.Rating> query, RatingSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.UserId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }
            
            if (search?.MovieId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.MovieId == search.MovieId);
            }

            return filteredQuery;
        }

    }
}