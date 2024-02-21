using eKino.Controllers;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Interfaces;
using eKino.Services.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eKinoAPI.Controllers;

[ApiController]
public class MoviesController : BaseCRUDController<eKino.Model.Movies, MoviesSearchObject, MovieUpsertRequest, MovieUpsertRequest>
{
    public MoviesController(ILogger<MoviesController> logger, IMoviesServices service)
        : base(logger, service)
    {

    }

    [HttpGet("{id}/recommend")]
    [AllowAnonymous]
    public virtual List<eKino.Model.Movies> Recommend(int id)
    {
        return (_service as IMoviesServices).Recommend(id);
    }

}

