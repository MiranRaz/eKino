using eKino.Controllers;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Interfaces;
using eKino.Services.Services;
using Microsoft.AspNetCore.Mvc;

namespace eKinoAPI.Controllers;

[ApiController]
public class MoviesController : BaseCRUDController<eKino.Model.Movies, MoviesSearchObject, MoviesInsertRequest, MoviesUpdateRequest>
{
    public MoviesController(ILogger<MoviesController> logger, IMoviesServices service)
        : base(logger, service)
    {
    }
}

