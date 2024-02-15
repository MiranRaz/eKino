using eKino.Model;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;

namespace eKino.Services.Interfaces
{
    public interface IAuditoriumService : ICRUDService<Auditorium, AuditoriumSearchObject, AuditoriumUpsertRequest, AuditoriumUpsertRequest>
    {
    }
}
