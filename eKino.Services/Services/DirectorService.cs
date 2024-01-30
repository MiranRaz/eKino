using System;
using AutoMapper;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eKino.Services.Services
{
    public class DirectorService :BaseService<Model.Director, Database.Director, DirectorSearchObject>, IDirectorService
    {
        public DirectorService(eKinoContext context, IMapper mapper)
            : base(context, mapper)
        {  
        }

        public override IQueryable<Database.Director> AddFilter(IQueryable<Database.Director> query,DirectorSearchObject? search)
        {
            if (!string.IsNullOrWhiteSpace(search?.Name) )
            {
                query = query.Where(x => x.FullName.StartsWith(search.Name));
            }

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                query = query.Where(x => x.FullName.Contains(search.FTS));
            }


            return base.AddFilter(query,  search);
        }

    }
}

