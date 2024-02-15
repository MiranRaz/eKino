using System;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Services.Database;

namespace eKino.Services.Interfaces
{
    public interface IUserService : ICRUDService<Model.User, Model.SearchObjects.UserSearchObject, UsersInsertRequest, UsersUpdateRequest>
    {
        public Task<Model.User> Login(string username, string password);
    }
}

