using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKino.Services.Interfaces
{
    public interface IRoleService : ICRUDService<Role, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
    }
}
