using eKino.Controllers;
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
    public class ProjectionController : BaseCRUDController<Model.Projection, ProjectionSearchObject, ProjectionUpsertRequest, ProjectionUpsertRequest>
    {
        public ProjectionController(ILogger<BaseCRUDController<Model.Projection, ProjectionSearchObject, ProjectionUpsertRequest, ProjectionUpsertRequest>> logger, IProjectionService service) : base(logger, service)
        {
        }
    }
}
