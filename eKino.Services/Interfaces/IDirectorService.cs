using System;
using eKino.Model.Requests;

namespace eKino.Services.Interfaces
{
    public interface IDirectorService : ICRUDService<Model.Director, Model.SearchObjects.DirectorSearchObject, DirectorUpsertRequest, DirectorUpsertRequest>
    {
    }
}

