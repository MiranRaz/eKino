using System;
using eKino.Model;
using eKino.Services.Interfaces;
using eKinoAPI.Controllers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eKino.Controllers
{
    [ApiController]
    [AllowAnonymous]
    public class DirectorController : BaseController<Model.Director, Model.SearchObjects.DirectorSearchObject>
    {
        public DirectorController(ILogger<BaseController<Director, Model.SearchObjects.DirectorSearchObject>> logger, IDirectorService service) : base(logger, service)
        {
        }
    }   
}

