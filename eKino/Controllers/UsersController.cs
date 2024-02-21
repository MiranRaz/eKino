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
[Route("[controller]")]
public class UsersController : BaseCRUDController<eKino.Model.User, UserSearchObject, UsersInsertRequest, UsersUpdateRequest>
{
    public UsersController(ILogger<UsersController> logger, IUserService service)
        :base(logger, service)
    {
    }

    public override Task<User> Insert([FromBody] UsersInsertRequest insert)
    {
        return base.Insert(insert);
    }

    public override Task<User> Update(int id, [FromBody] UsersUpdateRequest update)
    {
        return base.Update(id, update);
    }

    [HttpGet("checkusername/{username}")]
    [AllowAnonymous]
    public async Task<bool> UsernameExists(string username)
    {
        return await ((UserService)_service).UsernameExists(username);
    }
    [HttpGet("checkemail/{email}")]
    [AllowAnonymous]
    public async Task<bool> EmailExists(string email)
    {
        return await ((UserService)_service).EmailExists(email);
    }
    [HttpGet("checkphone/{phone}")]
    [AllowAnonymous]
    public async Task<bool> PhoneExists(string phone)
    {
        return await ((UserService)_service).PhoneExists(phone);
    }

    [HttpGet("getusername/{username}")]
    [AllowAnonymous]
    public async Task<bool> GetUserByUsername(string username)
    {
        return await ((UserService)_service).GetUserByUsername(username);
    }
}
