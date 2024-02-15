using eKino.Model;
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
    public class ReservationController : BaseCRUDController<Model.Reservation, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>
    {
        public ReservationController(ILogger<BaseCRUDController<Model.Reservation, ReservationSearchObject, ReservationUpsertRequest, ReservationUpsertRequest>> logger, IReservationService service) : base(logger, service)
        {
        }
    }
}
