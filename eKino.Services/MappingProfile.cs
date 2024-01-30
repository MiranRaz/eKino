using System;
using AutoMapper;

namespace eKino.Services.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // users
            CreateMap<Database.User, Model.User>();
            CreateMap<Database.UserRole, Model.UserRole>();
            CreateMap<Model.Requests.UsersInsertRequest, Database.User>();
            CreateMap<Model.Requests.UsersUpdateRequest, Database.User>();

            //movies
            CreateMap<Database.Movie, Model.Movies>();
            CreateMap<Model.Requests.MoviesInsertRequest, Database.Movie>();
            CreateMap<Model.Requests.MoviesUpdateRequest, Database.Movie>();

            //role
            CreateMap<Database.Role, Model.Role>();

            //director
            CreateMap<Database.Director, Model.Director>();

            // genre
            CreateMap<Database.Genre, Model.Genre>();
        }
    }
}

