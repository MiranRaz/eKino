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
    public class ReservationService : BaseCRUDService<Model.Reservation, Database.Reservation, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>, IReservationService
    {
        public ReservationService(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Reservation> AddFilter(IQueryable<Database.Reservation> query, ReservationSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.UserId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }
            
            if (search?.ProjectionId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.ProjectionId == search.ProjectionId);
            }

            if (!string.IsNullOrEmpty(search.MovieTitle))
            {
                filteredQuery = filteredQuery.Where(x => x.Projection.Movie.Title.Contains(search.MovieTitle));
            }

            if (search?.From != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DateOfReservation >= search.From.Value.Date);
            }

            if (search?.To != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DateOfReservation <= search.To.Value.Date);
            }

            return filteredQuery;
        }

        public override IQueryable<Database.Reservation> AddInclude(IQueryable<Database.Reservation> query, ReservationSearchObject search = null)
        {
            query = query.Include(x => x.User);
            query = query.Include(x => x.Projection.Movie);
            return base.AddInclude(query, search);
        }

    }
}