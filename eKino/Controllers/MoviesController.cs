using eKino.Model;
using eKino.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eKinoAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class MoviesController : ControllerBase
{
    private readonly IMoviesServices _movies;

    private readonly ILogger<MoviesController> _logger;

    public MoviesController(ILogger<MoviesController> logger,IMoviesServices movies)
    {
        _logger = logger;
        _movies = movies;
    }

    [HttpGet()]
    public IEnumerable<Movies> Get()
    {
       return _movies.Get();
    }
}

