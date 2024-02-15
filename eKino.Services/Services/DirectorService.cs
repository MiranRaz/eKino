using System;
using AutoMapper;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eKino.Services.Services
{
    public class DirectorService :BaseCRUDService<Model.Director, Database.Director, DirectorSearchObject, DirectorUpsertRequest, DirectorUpsertRequest>, IDirectorService
    {
        public DirectorService(eKinoContext context, IMapper mapper)
            : base(context, mapper)
        {  
        }

        public override IQueryable<Database.Director> AddFilter(IQueryable<Database.Director> query,DirectorSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.FullName) )
            {
                query = query.Where(x => x.FullName.StartsWith(search.FullName));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.FullName.Contains(search.FTS));
            }


            return base.AddFilter(query,  search);
        }

       
    }
}

