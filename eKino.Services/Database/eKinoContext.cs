using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using System.Net;

namespace eKino.Services.Database
{
    public partial class eKinoContext : DbContext
    {
        public eKinoContext()
        {
        }

        public eKinoContext(DbContextOptions<eKinoContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Auditorium> Auditoria { get; set; } = null!;
        public virtual DbSet<Director> Directors { get; set; } = null!;
        public virtual DbSet<Genre> Genres { get; set; } = null!;
        public virtual DbSet<IsDeleted> IsDeleteds { get; set; } = null!;
        public virtual DbSet<Movie> Movies { get; set; } = null!;
        public virtual DbSet<MovieGenre> MovieGenres { get; set; } = null!;
        public virtual DbSet<Projection> Projections { get; set; } = null!;
        public virtual DbSet<Rating> Ratings { get; set; } = null!;
        public virtual DbSet<Reservation> Reservations { get; set; } = null!;
        public virtual DbSet<Role> Roles { get; set; } = null!;
        public virtual DbSet<Transaction> Transactions { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;
        public virtual DbSet<UserRole> UserRoles { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Data Source=localhost,1433;Initial Catalog=eKino; user=SA; Password=admin123admin123;TrustServerCertificate=True");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Auditorium>(entity =>
            {
                entity.ToTable("Auditorium");

                entity.Property(e => e.AuditoriumId).HasColumnName("AuditoriumID");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<Director>(entity =>
            {
                entity.ToTable("Director");

                entity.Property(e => e.DirectorId).HasColumnName("DirectorID");

                entity.Property(e => e.Biography).HasMaxLength(500);

                entity.Property(e => e.FullName).HasMaxLength(50);
            });

            modelBuilder.Entity<Genre>(entity =>
            {
                entity.ToTable("Genre");

                entity.Property(e => e.GenreId).HasColumnName("GenreID");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<IsDeleted>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("IsDeleted");

                entity.Property(e => e.IsDeleted1).HasColumnName("isDeleted");
            });

            modelBuilder.Entity<Movie>(entity =>
            {
                entity.ToTable("Movie");

                entity.Property(e => e.MovieId).HasColumnName("MovieID");

                entity.Property(e => e.Description).HasMaxLength(200);

                entity.Property(e => e.DirectorId).HasColumnName("DirectorID");

                entity.Property(e => e.RunningTime).HasMaxLength(30);

                entity.Property(e => e.Title).HasMaxLength(50);

                entity.Property(e => e.Year).HasColumnType("date");

                entity.HasOne(d => d.Director)
                    .WithMany(p => p.Movies)
                    .HasForeignKey(d => d.DirectorId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Movie_Director");
            });

            modelBuilder.Entity<MovieGenre>(entity =>
            {
                entity.ToTable("MovieGenre");

                entity.Property(e => e.MovieGenreId).HasColumnName("MovieGenreID");

                entity.Property(e => e.GenreId).HasColumnName("GenreID");

                entity.Property(e => e.MovieId).HasColumnName("MovieID");

                entity.HasOne(d => d.Genre)
                    .WithMany(p => p.MovieGenres)
                    .HasForeignKey(d => d.GenreId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_MovieGenre_Genre");

                entity.HasOne(d => d.Movie)
                    .WithMany(p => p.MovieGenres)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_MovieGenre_Movie");
            });

            modelBuilder.Entity<Projection>(entity =>
            {
                entity.ToTable("Projection");

                entity.Property(e => e.ProjectionId).HasColumnName("ProjectionID");

                entity.Property(e => e.AuditoriumId).HasColumnName("AuditoriumID");

                entity.Property(e => e.DateOfProjection).HasColumnType("datetime");

                entity.Property(e => e.MovieId).HasColumnName("MovieID");

                entity.Property(e => e.TicketPrice).HasColumnType("decimal(10, 2)");

                entity.HasOne(d => d.Auditorium)
                    .WithMany(p => p.Projections)
                    .HasForeignKey(d => d.AuditoriumId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Projection_Auditorium");

                entity.HasOne(d => d.Movie)
                    .WithMany(p => p.Projections)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Projection_Movie");
            });

            modelBuilder.Entity<Rating>(entity =>
            {
                entity.ToTable("Rating");

                entity.Property(e => e.RatingId).HasColumnName("RatingID");

                entity.Property(e => e.DateOfRating).HasColumnType("date");

                entity.Property(e => e.MovieId).HasColumnName("MovieID");

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Movie)
                    .WithMany(p => p.Ratings)
                    .HasForeignKey(d => d.MovieId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Rating_Movie");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Ratings)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Rating_User");
            });

            modelBuilder.Entity<Reservation>(entity =>
            {
                entity.ToTable("Reservation");

                entity.Property(e => e.ReservationId).HasColumnName("ReservationID");

                entity.Property(e => e.Column).HasMaxLength(50);

                entity.Property(e => e.DateOfReservation).HasColumnType("datetime");

                entity.Property(e => e.NumTicket).HasMaxLength(50);

                entity.Property(e => e.ProjectionId).HasColumnName("ProjectionID");

                entity.Property(e => e.Row).HasMaxLength(50);

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Projection)
                    .WithMany(p => p.Reservations)
                    .HasForeignKey(d => d.ProjectionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Reservation_Projection");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Reservations)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Reservation_User");
            });

            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("Role");

                entity.Property(e => e.RoleId).HasColumnName("RoleID");

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<Transaction>(entity =>
            {
                entity.ToTable("Transaction");

                entity.Property(e => e.TransactionId).HasColumnName("TransactionID");

                entity.Property(e => e.Amount).HasColumnType("decimal(10, 2)");

                entity.Property(e => e.DateOfTransaction).HasColumnType("date");

                entity.Property(e => e.ReservationId).HasColumnName("ReservationID");

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Reservation)
                    .WithMany(p => p.Transactions)
                    .HasForeignKey(d => d.ReservationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Transaction_Reservation");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Transactions)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Transaction_User");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User");

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.FirstName).HasMaxLength(50);

                entity.Property(e => e.LastName).HasMaxLength(100);

                entity.Property(e => e.PasswordHash).HasMaxLength(50);

                entity.Property(e => e.PasswordSalt).HasMaxLength(50);

                entity.Property(e => e.Phone).HasMaxLength(50);

                entity.Property(e => e.Username).HasMaxLength(50);
            });

            modelBuilder.Entity<UserRole>(entity =>
            {
                entity.ToTable("UserRole");

                entity.Property(e => e.UserRoleId).HasColumnName("UserRoleID");

                entity.Property(e => e.DateModified).HasColumnType("date");

                entity.Property(e => e.RoleId).HasColumnName("RoleID");

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.UserRoles)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserRole_Role");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserRoles)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserRole_User");
            });

            #region Roles
            modelBuilder.Entity<Role>().HasData(new Role { RoleId = 1, Name = "Administrator" });
            modelBuilder.Entity<Role>().HasData(new Role { RoleId = 2, Name = "Client" });
            #endregion

            #region Users - Admin and client
            int userID = 0;

            //u:admin p:admin
            modelBuilder.Entity<User>().HasData(new User
            {
                UserId = ++userID,
                FirstName = "Administrator",
                LastName = "Administrator",
                Email = "admin@fit.ba",
                Username = "admin",
                PasswordHash = "3U3v9TFBIOt0cK/n//Z6j1h51QQ=",
                PasswordSalt = "i2iW2ERv5G1K0+Kdr6pQGg==",
                Phone = "061456789",
                Status = true
            });

            //u:client p:client
            modelBuilder.Entity<User>().HasData(new User
            {
                UserId = ++userID,
                FirstName = "Client",
                LastName = "Client",
                Email = "client@fit.ba",
                Username = "client",
                PasswordHash = "Qt4/SE4hNB9rKyspn+e8q4C79Sw=",
                PasswordSalt = "l6n9Ck0LvsyNX1/V47AePQ==",
                Phone = "061123123",
                Status = true
            });


            modelBuilder.Entity<UserRole>().HasData(new UserRole() { UserRoleId = 1, UserId = 1, RoleId = 1, DateModified = DateTime.Today });
            modelBuilder.Entity<UserRole>().HasData(new UserRole() { UserRoleId = 2, UserId = 2, RoleId = 2, DateModified = DateTime.Today });
            #endregion

            #region Users - Client1 through Client10
            //u:client1 p:client
            for (int i = 1; i <= 10; i++)
            {
                int UID = ++userID;
                modelBuilder.Entity<User>().HasData(new User
                {
                    UserId = UID,
                    FirstName = "Client " + i,
                    LastName = "Client " + i,
                    Email = "client" + i + "@fit.ba",
                    Username = "client" + i,
                    PasswordHash = "Qt4/SE4hNB9rKyspn+e8q4C79Sw=",
                    PasswordSalt = "l6n9Ck0LvsyNX1/V47AePQ==",
                    Phone = "061123123",
                    Status = true
                });
                modelBuilder.Entity<UserRole>().HasData(new UserRole() { UserRoleId = UID, UserId = UID, RoleId = 2, DateModified = DateTime.Today });
            }
            #endregion

            #region Genre
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 1, Name = "Action" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 2, Name = "Drama" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 3, Name = "Horror" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 4, Name = "Comedy" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 5, Name = "Western" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 6, Name = "Thriller" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 7, Name = "Sci-fi" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 8, Name = "Romance" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 9, Name = "Crime" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 10, Name = "Adventure" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 11, Name = "Fantasy" });
            modelBuilder.Entity<Genre>().HasData(new Genre() { GenreId = 12, Name = "Mystery" });
            #endregion

            #region Director
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 1, FullName = "Taika Waititi", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 2, FullName = "Joseph Kosinski", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 3, FullName = "David Leitch", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 4, FullName = "Julius Avery", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 5, FullName = "Peter Jackson", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 6, FullName = "Colin Trevorrow", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 7, FullName = "Baltasar Kormákur", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 8, FullName = "James Cameron", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 9, FullName = "Sergio Leone", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 10, FullName = "Matt Reeves", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 11, FullName = "Robert Zemeckis", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 12, FullName = "Mark Steven Johnson", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 13, FullName = "Ti West", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 14, FullName = "Andrew Dominik", Biography = "", Photo = new byte[0] });
            modelBuilder.Entity<Director>().HasData(new Director() { DirectorId = 15, FullName = "Robert Eggers", Biography = "", Photo = new byte[0] });
            #endregion

            #region Movies and MovieGenres

            int MovieGenreID = 0;

            string thorImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/thor.jpg";

            byte[] thorImageBytes;
            using (var webClient = new WebClient())
            {
                thorImageBytes = webClient.DownloadData(thorImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 1,
                DirectorId = 1,
                Title = "Thor: Love and Thunder",
                Description = "Thor desc",
                Year = new DateTime(2020, 9, 13, 20, 0, 0),
                RunningTime = "1h 45min",
                Photo = thorImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 1, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 1, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 1, GenreId = 4 });

            string topgunmaverickImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/topgunmaverick.jpg";

            byte[] topgunmaverickImageBytes;
            using (var webClient = new WebClient())
            {
                topgunmaverickImageBytes = webClient.DownloadData(topgunmaverickImageUrl);
            }

            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 2,
                DirectorId = 2,
                Title = "Top Gun: Maverick",
                Description = "Top Gun: Maverick desc",
                Year = new DateTime(2023, 9, 13, 20, 0, 0),
                RunningTime = "1h 30min",
                Photo = topgunmaverickImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 2, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 2, GenreId = 2 }
            );
            string bullettrainImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/bullettrain.jpg";

            byte[] bullettrainImageBytes;
            using (var webClient = new WebClient())
            {
                bullettrainImageBytes = webClient.DownloadData(bullettrainImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 3,
                DirectorId = 3,
                Title = "Bullet Train",
                Description = "Bullet Train desc",
                Year = new DateTime(2022, 9, 13, 20, 0, 0),
                RunningTime = "2h 24min",
                Photo = bullettrainImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 3, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 3, GenreId = 4 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 3, GenreId = 6 }
            );
            string samaritanImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/samaritan.jpg";

            byte[] samaritanImageBytes;
            using (var webClient = new WebClient())
            {
                samaritanImageBytes = webClient.DownloadData(samaritanImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 4,
                DirectorId = 4,
                Title = "Samaritan",
                Description = "A young boy learns that a superhero who was thought to have gone missing after an epic battle twenty years ago may in fact still be around.",
                Year = new DateTime(2018, 9, 13, 20, 0, 0),
                RunningTime = "2h 12min",
                Photo = samaritanImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 4, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 4, GenreId = 2 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 4, GenreId = 11 }
            );
            string fellowshipImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/fellowship.jpg";

            byte[] fellowshipImageBytes;
            using (var webClient = new WebClient())
            {
                fellowshipImageBytes = webClient.DownloadData(fellowshipImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 5,
                DirectorId = 5,
                Title = "The Lord of the Rings: The Fellowship of the Ring",
                Description = "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.",
                Year = new DateTime(2008, 9, 13, 20, 0, 0),
                RunningTime = "3h 22min",
                Photo = fellowshipImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 5, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 5, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 5, GenreId = 11 }
            );
            string dominionImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/dominion.jpg";

            byte[] dominionImageBytes;
            using (var webClient = new WebClient())
            {
                dominionImageBytes = webClient.DownloadData(dominionImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 6,
                DirectorId = 6,
                Title = "Jurassic World Dominion",
                Description = "Four years after the destruction of Isla Nublar, Biosyn operatives attempt to track down Maisie Lockwood, while Dr Ellie Sattler investigates a genetically engineered swarm of giant insects.",
                Year = new DateTime(2022, 9, 13, 20, 0, 0),
                RunningTime = "1h 55min",
                Photo = dominionImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 6, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 6, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 6, GenreId = 7 }
            );
            string beastImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/beast.jpg";

            byte[] beastImageBytes;
            using (var webClient = new WebClient())
            {
                beastImageBytes = webClient.DownloadData(beastImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 7,
                DirectorId = 7,
                Title = "Beast",
                Description = "A father and his two teenage daughters find themselves hunted by a massive rogue lion intent on proving that the Savanna has but one apex predator.",
                Year = new DateTime(2001, 9, 13, 20, 0, 0),
                RunningTime = "1h 27min",
                Photo = beastImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 7, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 7, GenreId = 2 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 7, GenreId = 3 }
            );
            string avatarImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/avatar.jpg";

            byte[] avatarImageBytes;
            using (var webClient = new WebClient())
            {
                avatarImageBytes = webClient.DownloadData(avatarImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 8,
                DirectorId = 8,
                Title = "Avatar",
                Description = "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
                Year = new DateTime(2009, 9, 13, 20, 0, 0),
                RunningTime = "3h 15min",
                Photo = avatarImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 8, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 8, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 8, GenreId = 11 }
            );
            string goodbaduglyImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/goodbadugly.jpg";

            byte[] goodbaduglyImageBytes;
            using (var webClient = new WebClient())
            {
                goodbaduglyImageBytes = webClient.DownloadData(goodbaduglyImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 9,
                DirectorId = 9,
                Title = "The Good, the Bad and the Ugly",
                Description = "A bounty hunting scam joins two men in an uneasy alliance against a third in a race to find a fortune in gold buried in a remote cemetery.",
                Year = new DateTime(1966, 9, 13, 20, 0, 0),
                RunningTime = "2h 22min",
                Photo = goodbaduglyImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 9, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 9, GenreId = 5 }
            );
            string batmanImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/batman.jpg";

            byte[] batmanImageBytes;
            using (var webClient = new WebClient())
            {
                batmanImageBytes = webClient.DownloadData(batmanImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 10,
                DirectorId = 10,
                Title = "The Batman",
                Description = "When a sadistic serial killer begins murdering key political figures in Gotham, Batman is forced to investigate the city's hidden corruption and question his family's involvement.",
                Year = new DateTime(2009, 9, 13, 20, 0, 0),
                RunningTime = "2h 41min",
                Photo = batmanImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 10, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 10, GenreId = 9 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 10, GenreId = 2 }
            );
            string pinocchioImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/pinocchio.jpg";

            byte[] pinocchioImageBytes;
            using (var webClient = new WebClient())
            {
                pinocchioImageBytes = webClient.DownloadData(pinocchioImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 11,
                DirectorId = 11,
                Title = "Pinocchio",
                Description = "A puppet is brought to life by a fairy, who assigns him to lead a virtuous life in order to become a real boy.",
                Year = new DateTime(2012, 9, 13, 20, 0, 0),
                RunningTime = "1h 21min",
                Photo = pinocchioImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 11, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 11, GenreId = 4 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 11, GenreId = 2 }
            );
            string loveinthevillaImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/loveinthevilla.jpg";

            byte[] loveinthevillaImageBytes;
            using (var webClient = new WebClient())
            {
                loveinthevillaImageBytes = webClient.DownloadData(loveinthevillaImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 12,
                DirectorId = 12,
                Title = "Love in the Villa",
                Description = "A young woman takes a trip to romantic Verona, Italy, after a breakup, only to find that the villa she reserved was double-booked, and she'll have to share her vacation with a cynical British man.",
                Year = new DateTime(2017, 9, 13, 20, 0, 0),
                RunningTime = "1h 35min",
                Photo = loveinthevillaImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 12, GenreId = 4 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 12, GenreId = 8 }
            );
            string xImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/x.jpg";

            byte[] xImageBytes;
            using (var webClient = new WebClient())
            {
                xImageBytes = webClient.DownloadData(xImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 13,
                DirectorId = 13,
                Title = "X",
                Description = "In 1979, a group of young filmmakers set out to make an adult film in rural Texas, but when their reclusive, elderly hosts catch them in the act, the cast find themselves fighting for their lives.",
                Year = new DateTime(2014, 9, 13, 20, 0, 0),
                RunningTime = "2h 15min",
                Photo = xImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 13, GenreId = 3 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 13, GenreId = 12 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 13, GenreId = 6 }
            );
            string blondeImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/blonde.jpg";

            byte[] blondeImageBytes;
            using (var webClient = new WebClient())
            {
                blondeImageBytes = webClient.DownloadData(blondeImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 14,
                DirectorId = 14,
                Title = "Blonde",
                Description = "A fictionalized chronicle of the inner life of Marilyn Monroe.",
                Year = new DateTime(2011, 9, 13, 20, 0, 0),
                RunningTime = "2h 11min",
                Photo = blondeImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 14, GenreId = 4 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 14, GenreId = 8 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 14, GenreId = 12 }
            );
            string northmanImageUrl = "https://raw.githubusercontent.com/MiranRaz/eKino/main/eKino.Services/Images/northman.jpg";

            byte[] northmanImageBytes;
            using (var webClient = new WebClient())
            {
                northmanImageBytes = webClient.DownloadData(northmanImageUrl);
            }
            modelBuilder.Entity<Movie>().HasData(new Movie()
            {
                MovieId = 15,
                DirectorId = 15,
                Title = "The Northman",
                Description = "From visionary director Robert Eggers comes The Northman, an action-filled epic that follows a young Viking prince on his quest to avenge his father's murder.",
                Year = new DateTime(2021, 9, 13, 20, 0, 0),
                RunningTime = "2h 5min",
                Photo = northmanImageBytes
            });
            modelBuilder.Entity<MovieGenre>().HasData(
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 15, GenreId = 1 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 15, GenreId = 10 },
                    new MovieGenre { MovieGenreId = ++MovieGenreID, MovieId = 15, GenreId = 2 }
            );
            #endregion

            #region Auditoriums
            for (int i = 1; i <= 3; i++)
            {
                modelBuilder.Entity<Auditorium>().HasData(new Auditorium()
                {
                    AuditoriumId = i,
                    Name = "Auditorium " + i
                });
            }
            modelBuilder.Entity<Auditorium>().HasData(new Auditorium()
            {
                AuditoriumId = 4,
                Name = "Auditorium 4 - 3D"
            });
            modelBuilder.Entity<Auditorium>().HasData(new Auditorium()
            {
                AuditoriumId = 5,
                Name = "Auditorium 5 - IMAX"
            });
            #endregion

            #region Projections

            int ProjectionID = 0;

            // Loop through each projection
            for (int i = 0; i < 4; i++) // Change 4 to the number of projections you want to generate
            {
                // Generate a random number of days between 1 and 30
                Random rnd = new Random();
                int randomDays = rnd.Next(1, 31);
                int randomHours = rnd.Next(1, 24);
                int randomMinutes = rnd.Next(1, 60);

                modelBuilder.Entity<Projection>().HasData(new Projection()
                {
                    ProjectionId = ++ProjectionID,
                    DateOfProjection = DateTime.Now.AddDays(randomDays).AddHours(randomHours).AddMinutes(randomMinutes),
                    AuditoriumId = (ProjectionID % 5) + 1,
                    MovieId = ProjectionID,
                    TicketPrice = 5.50m
                });
            }


            int ReservationID = 0;
            modelBuilder.Entity<Reservation>().HasData(new Reservation()
            {
                ReservationId = ++ReservationID,
                ProjectionId = 1,
                UserId = 3,
                Row = "A1,A2,B1",
                Column = "x",
                NumTicket = "3",
                DateOfReservation = new DateTime(2022, 9, 11, 15, 18, 30)
            });
            modelBuilder.Entity<Reservation>().HasData(new Reservation()
            {
                ReservationId = ++ReservationID,
                ProjectionId = 2,
                UserId = 3,
                Row = "C1,D2,E1",
                Column = "x",
                NumTicket = "3",
                DateOfReservation = new DateTime(2022, 9, 12, 15, 20, 0)
            });
            modelBuilder.Entity<Reservation>().HasData(new Reservation()
            {
                ReservationId = ++ReservationID,
                ProjectionId = 3,
                UserId = 3,
                Row = "E4,E5",
                Column = "x",
                NumTicket = "3",
                DateOfReservation = new DateTime(2022, 9, 13, 15, 15, 0)
            });

            #endregion

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
