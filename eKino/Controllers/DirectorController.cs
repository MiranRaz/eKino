using System;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Services.Interfaces;
using eKinoAPI.Controllers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eKino.Controllers
{
    [ApiController]
    [AllowAnonymous]
    public class DirectorController : BaseCRUDController<Model.Director, Model.SearchObjects.DirectorSearchObject,DirectorUpsertRequest, DirectorUpsertRequest>
    {
        public DirectorController(ILogger<BaseCRUDController<Director, Model.SearchObjects.DirectorSearchObject, DirectorUpsertRequest, DirectorUpsertRequest>> logger, IDirectorService service) : base(logger, service)
        {
        }
       
    }   
}

