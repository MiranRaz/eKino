using System;
using System.Collections.Generic;

namespace eKino.Services.Database
{
    public partial class User
    {
        public User()
        {
            Ratings = new HashSet<Rating>();
            Reservations = new HashSet<Reservation>();
            Transactions = new HashSet<Transaction>();
            UserRoles = new HashSet<UserRole>();
        }

        public int UserId { get; set; }
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string? Email { get; set; }
        public string? Phone { get; set; }
        public string Username { get; set; } = null!;
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
        public bool Status { get; set; }

        public virtual ICollection<Rating> Ratings { get; set; }
        public virtual ICollection<Reservation> Reservations { get; set; }
        public virtual ICollection<Transaction> Transactions { get; set; }
        public virtual ICollection<UserRole> UserRoles { get; set; }
    }
}
