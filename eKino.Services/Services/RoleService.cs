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
    public class RoleService : BaseCRUDService<Model.Role, Database.Role, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>, IRoleService
    {
        public RoleService(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Role> AddFilter(IQueryable<Database.Role> query, RoleSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.RoleId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.RoleId == search.RoleId);
            }
            
            if (search?.Name != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Name == search.Name);
            }

            return filteredQuery; 
        }

    }
}