using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eKino.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class RoleController : BaseCRUDController<Model.Role, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(ILogger<BaseCRUDController<Model.Role, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>> logger, IRoleService service) : base(logger, service)
        {
        }
    }
}
