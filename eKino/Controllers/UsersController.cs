using eKino.Controllers;
using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Interfaces;
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

    [Authorize(Roles = "Administrator")]
    public override Task<User> Insert([FromBody] UsersInsertRequest insert)
    {
        return base.Insert(insert);
    }

    [Authorize(Roles = "Administrator")]
    public override Task<User> Update(int id, [FromBody] UsersUpdateRequest update)
    {
        return base.Update(id, update);
    }
}

