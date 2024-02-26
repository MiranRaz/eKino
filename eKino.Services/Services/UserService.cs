using System;
using System.Runtime.InteropServices;
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

        public async Task<Model.User?> GetUserByUsername(string username)
        {
            var userEntity = await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
            return userEntity != null ? _mapper.Map<Model.User>(userEntity) : null;
        }

        public async Task<bool> UsernameExists(string username)
        {
            return await _context.Users.AnyAsync(u => u.Username == username);
        }

        public async Task<bool> EmailExists(string email)
        {
            return await _context.Users.AnyAsync(u => u.Email == email);
        }

        public async Task<bool> PhoneExists(string phone)
        {
            return await _context.Users.AnyAsync(u => u.Phone == phone);
        }

        public override async Task<Model.User> Insert(UsersInsertRequest insert)
        {
            var entity = _mapper.Map<Database.User>(insert);
            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, insert.Password);

            _context.Users.Add(entity);
            await _context.SaveChangesAsync();

            foreach (var roleId in insert.RoleIdList)
            {
                var role = await _context.Roles.FindAsync(roleId);
                if (role == null)
                {
                    throw new InvalidOperationException($"Role with ID {roleId} not found.");
                }

                var userRole = new Database.UserRole
                {
                    RoleId = roleId,
                    Role = role,  // Set the Role navigation property
                    UserId = entity.UserId,
                    DateModified = DateTime.Now
                };

                _context.UserRoles.Add(userRole);
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.User>(entity);
        }

        public override async Task<Model.User> Update(int id, UsersUpdateRequest update)
        {
           
            var entity = await _context.Users.Include(x => x.UserRoles).FirstOrDefaultAsync(x => x.UserId == id);

            if (entity == null)
            {
                return null;
            }

            _mapper.Map(update, entity);

            if (!string.IsNullOrEmpty(update.Password))
            {
                entity.PasswordSalt = GenerateSalt();
                entity.PasswordHash = GenerateHash(entity.PasswordSalt, update.Password);
            }

            foreach (var roleId in update.RoleIdList)
            {
                if (!entity.UserRoles.Any(x => x.RoleId == roleId))
                {
                    entity.UserRoles.Add(new Database.UserRole
                    {
                        RoleId = roleId,
                        DateModified = DateTime.Now
                    });
                }
            }

            foreach (var userRole in entity.UserRoles.ToList())
            {
                if (!update.RoleIdList.Contains(userRole.RoleId))
                {
                    entity.UserRoles.Remove(userRole);
                }
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.User>(entity);
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
            query = query.Include(u => u.UserRoles).ThenInclude(ur => ur.Role);
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.User> AddFilter(IQueryable<Database.User> query, UserSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Username))
            {
                filteredQuery = filteredQuery.Where(x => x.Username.Contains(search.Username));
            }

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => (x.FirstName + " " + x.LastName).Contains(search.Name));
            }

            return filteredQuery;
        }
    }
}

