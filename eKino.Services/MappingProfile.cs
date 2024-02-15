using System;
using AutoMapper;
using eKino.Model.Requests;

namespace eKino.Services.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Auditorium, Model.Auditorium>();
            CreateMap<Database.Director, Model.Director>();
            CreateMap<Database.Genre, Model.Genre>();
            CreateMap<Database.Movie, Model.Movies>();
            CreateMap<Database.MovieGenre, Model.MovieGenre>();
            CreateMap<Database.Projection, Model.Projection>();
            CreateMap<Database.Reservation, Model.Reservation>();
            CreateMap<Database.Rating, Model.Rating>();
            CreateMap<Database.Transaction, Model.Transaction>();
            CreateMap<Database.User, Model.User>();
            CreateMap<Database.UserRole, Model.UserRole>();
            CreateMap<Database.Role, Model.Role>();

            CreateMap<AuditoriumUpsertRequest, Database.Auditorium>();
            CreateMap<DirectorUpsertRequest, Database.Director>();
            CreateMap<GenreUpsertRequest, Database.Genre>();
            CreateMap<MovieUpsertRequest, Database.Movie>();
            CreateMap<ProjectionUpsertRequest, Database.Projection>();
            CreateMap<ReservationUpsertRequest, Database.Reservation>();
            CreateMap<RatingUpsertRequest, Database.Rating>();
            CreateMap<TransactionUpsertRequest, Database.Transaction>();
            CreateMap<UsersInsertRequest, Database.User>();
            CreateMap<UsersUpdateRequest, Database.User>();
            CreateMap<RoleUpsertRequest, Database.Role>();

        }
    }
}

