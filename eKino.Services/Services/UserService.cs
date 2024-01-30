using System;
using System.Security.Cryptography;
using System.Text;
using AutoMapper;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eKino.Services.Services
{
    public class UserService : BaseCRUDService<Model.User, Database.User, UserSearchObject, UsersInsertRequest, UsersUpdateRequest>, IUserService 
    {
       
        public UserService(eKinoContext context, IMapper mapper)
            : base(context, mapper)
        {
       
        }

        // login
        public async Task<Model.User> Login(string username, string password)
        {
            var entity = await _context.Users.Include("UserRoles.Role").FirstOrDefaultAsync(x => x.Username == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.PasswordSalt, password);

            if( hash != entity.PasswordHash)
            {
                return null;
            }

            return _mapper.Map<Model.User>(entity);
        }

        // hash and salt
        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);
            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        // insert and update methods
        public override async Task BeforeInsert(User entity, UsersInsertRequest insert)
        {
            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, insert.Password);
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject? search = null)
        {
            if(search?.IsRoleIncluded == true)
            {
                query = query.Include("UserRoles.Role");
            }
            return base.AddInclude(query, search);
        }

       
    }
}

