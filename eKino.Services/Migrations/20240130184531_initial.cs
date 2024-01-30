using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKino.Services.Migrations
{
    public partial class initial : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Auditorium",
                columns: table => new
                {
                    AuditoriumID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Auditorium", x => x.AuditoriumID);
                });

            migrationBuilder.CreateTable(
                name: "Director",
                columns: table => new
                {
                    DirectorID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FullName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Biography = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    Photo = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Director", x => x.DirectorID);
                });

            migrationBuilder.CreateTable(
                name: "Genre",
                columns: table => new
                {
                    GenreID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Genre", x => x.GenreID);
                });

            migrationBuilder.CreateTable(
                name: "IsDeleted",
                columns: table => new
                {
                    isDeleted = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "Role",
                columns: table => new
                {
                    RoleID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Role", x => x.RoleID);
                });

            migrationBuilder.CreateTable(
                name: "User",
                columns: table => new
                {
                    UserID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Phone = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Username = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Status = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_User", x => x.UserID);
                });

            migrationBuilder.CreateTable(
                name: "Movie",
                columns: table => new
                {
                    MovieID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Year = table.Column<DateTime>(type: "date", nullable: false),
                    RunningTime = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Photo = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    DirectorID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Movie", x => x.MovieID);
                    table.ForeignKey(
                        name: "FK_Movie_Director",
                        column: x => x.DirectorID,
                        principalTable: "Director",
                        principalColumn: "DirectorID");
                });

            migrationBuilder.CreateTable(
                name: "UserRole",
                columns: table => new
                {
                    UserRoleID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    RoleID = table.Column<int>(type: "int", nullable: false),
                    DateModified = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRole", x => x.UserRoleID);
                    table.ForeignKey(
                        name: "FK_UserRole_Role",
                        column: x => x.RoleID,
                        principalTable: "Role",
                        principalColumn: "RoleID");
                    table.ForeignKey(
                        name: "FK_UserRole_User",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "MovieGenre",
                columns: table => new
                {
                    MovieGenreID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MovieID = table.Column<int>(type: "int", nullable: false),
                    GenreID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MovieGenre", x => x.MovieGenreID);
                    table.ForeignKey(
                        name: "FK_MovieGenre_Genre",
                        column: x => x.GenreID,
                        principalTable: "Genre",
                        principalColumn: "GenreID");
                    table.ForeignKey(
                        name: "FK_MovieGenre_Movie",
                        column: x => x.MovieID,
                        principalTable: "Movie",
                        principalColumn: "MovieID");
                });

            migrationBuilder.CreateTable(
                name: "Projection",
                columns: table => new
                {
                    ProjectionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DateOfProjection = table.Column<DateTime>(type: "date", nullable: true),
                    AuditoriumID = table.Column<int>(type: "int", nullable: false),
                    MovieID = table.Column<int>(type: "int", nullable: false),
                    TicketPrice = table.Column<decimal>(type: "decimal(10,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Projection", x => x.ProjectionID);
                    table.ForeignKey(
                        name: "FK_Projection_Auditorium",
                        column: x => x.AuditoriumID,
                        principalTable: "Auditorium",
                        principalColumn: "AuditoriumID");
                    table.ForeignKey(
                        name: "FK_Projection_Movie",
                        column: x => x.MovieID,
                        principalTable: "Movie",
                        principalColumn: "MovieID");
                });

            migrationBuilder.CreateTable(
                name: "Rating",
                columns: table => new
                {
                    RatingID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DateOfRating = table.Column<DateTime>(type: "date", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    MovieID = table.Column<int>(type: "int", nullable: false),
                    Value = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rating", x => x.RatingID);
                    table.ForeignKey(
                        name: "FK_Rating_Movie",
                        column: x => x.MovieID,
                        principalTable: "Movie",
                        principalColumn: "MovieID");
                    table.ForeignKey(
                        name: "FK_Rating_User",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "Reservation",
                columns: table => new
                {
                    ReservationID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    ProjectionID = table.Column<int>(type: "int", nullable: false),
                    DateOfReservation = table.Column<DateTime>(type: "date", nullable: true),
                    Row = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    Column = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    NumTicket = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reservation", x => x.ReservationID);
                    table.ForeignKey(
                        name: "FK_Reservation_Projection",
                        column: x => x.ProjectionID,
                        principalTable: "Projection",
                        principalColumn: "ProjectionID");
                    table.ForeignKey(
                        name: "FK_Reservation_User",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.CreateTable(
                name: "Transaction",
                columns: table => new
                {
                    TransactionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DateOfTransaction = table.Column<DateTime>(type: "date", nullable: true),
                    UserID = table.Column<int>(type: "int", nullable: false),
                    ReservationID = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(10,2)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transaction", x => x.TransactionID);
                    table.ForeignKey(
                        name: "FK_Transaction_Reservation",
                        column: x => x.ReservationID,
                        principalTable: "Reservation",
                        principalColumn: "ReservationID");
                    table.ForeignKey(
                        name: "FK_Transaction_User",
                        column: x => x.UserID,
                        principalTable: "User",
                        principalColumn: "UserID");
                });

            migrationBuilder.InsertData(
                table: "Auditorium",
                columns: new[] { "AuditoriumID", "Name" },
                values: new object[,]
                {
                    { 1, "Auditorium 1" },
                    { 2, "Auditorium 2" },
                    { 3, "Auditorium 3" },
                    { 4, "Auditorium 4 - 3D" },
                    { 5, "Auditorium 5 - IMAX" }
                });

            migrationBuilder.InsertData(
                table: "Director",
                columns: new[] { "DirectorID", "Biography", "FullName", "Photo" },
                values: new object[,]
                {
                    { 1, "", "Taika Waititi", new byte[0] },
                    { 2, "", "Joseph Kosinski", new byte[0] },
                    { 3, "", "David Leitch", new byte[0] },
                    { 4, "", "Julius Avery", new byte[0] },
                    { 5, "", "Peter Jackson", new byte[0] },
                    { 6, "", "Colin Trevorrow", new byte[0] },
                    { 7, "", "Baltasar Kormákur", new byte[0] },
                    { 8, "", "James Cameron", new byte[0] },
                    { 9, "", "Sergio Leone", new byte[0] },
                    { 10, "", "Matt Reeves", new byte[0] },
                    { 11, "", "Robert Zemeckis", new byte[0] },
                    { 12, "", "Mark Steven Johnson", new byte[0] },
                    { 13, "", "Ti West", new byte[0] },
                    { 14, "", "Andrew Dominik", new byte[0] },
                    { 15, "", "Robert Eggers", new byte[0] }
                });

            migrationBuilder.InsertData(
                table: "Genre",
                columns: new[] { "GenreID", "Name" },
                values: new object[,]
                {
                    { 1, "Action" },
                    { 2, "Drama" },
                    { 3, "Horror" },
                    { 4, "Comedy" },
                    { 5, "Western" },
                    { 6, "Thriller" },
                    { 7, "Sci-fi" },
                    { 8, "Romance" },
                    { 9, "Crime" },
                    { 10, "Adventure" },
                    { 11, "Fantasy" },
                    { 12, "Mystery" }
                });

            migrationBuilder.InsertData(
                table: "Role",
                columns: new[] { "RoleID", "Name" },
                values: new object[,]
                {
                    { 1, "Administrator" },
                    { 2, "Client" }
                });

            migrationBuilder.InsertData(
                table: "User",
                columns: new[] { "UserID", "Email", "FirstName", "LastName", "PasswordHash", "PasswordSalt", "Phone", "Status", "Username" },
                values: new object[,]
                {
                    { 1, "admin@fit.ba", "Administrator", "Administrator", "3U3v9TFBIOt0cK/n//Z6j1h51QQ=", "i2iW2ERv5G1K0+Kdr6pQGg==", "061456789", true, "admin" },
                    { 2, "client@fit.ba", "Client", "Client", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client" },
                    { 3, "client1@fit.ba", "Client 1", "Client 1", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client1" },
                    { 4, "client2@fit.ba", "Client 2", "Client 2", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client2" },
                    { 5, "client3@fit.ba", "Client 3", "Client 3", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client3" },
                    { 6, "client4@fit.ba", "Client 4", "Client 4", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client4" },
                    { 7, "client5@fit.ba", "Client 5", "Client 5", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client5" },
                    { 8, "client6@fit.ba", "Client 6", "Client 6", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client6" }
                });

            migrationBuilder.InsertData(
                table: "User",
                columns: new[] { "UserID", "Email", "FirstName", "LastName", "PasswordHash", "PasswordSalt", "Phone", "Status", "Username" },
                values: new object[,]
                {
                    { 9, "client7@fit.ba", "Client 7", "Client 7", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client7" },
                    { 10, "client8@fit.ba", "Client 8", "Client 8", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client8" },
                    { 11, "client9@fit.ba", "Client 9", "Client 9", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client9" },
                    { 12, "client10@fit.ba", "Client 10", "Client 10", "Qt4/SE4hNB9rKyspn+e8q4C79Sw=", "l6n9Ck0LvsyNX1/V47AePQ==", "061123123", true, "client10" }
                });

            migrationBuilder.InsertData(
                table: "Movie",
                columns: new[] { "MovieID", "Description", "DirectorID", "Photo", "RunningTime", "Title", "Year" },
                values: new object[,]
                {
                    { 1, "Thor desc", 1, new byte[0], "100", "Thor: Love and Thunder", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, "Top Gun: Maverick desc", 2, new byte[0], "100", "Top Gun: Maverick", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, "Bullet Train desc", 3, new byte[0], "100", "Bullet Train", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 4, "A young boy learns that a superhero who was thought to have gone missing after an epic battle twenty years ago may in fact still be around.", 4, new byte[0], "100", "Samaritan", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.", 5, new byte[0], "100", "The Lord of the Rings: The Fellowship of the Ring", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 6, "Four years after the destruction of Isla Nublar, Biosyn operatives attempt to track down Maisie Lockwood, while Dr Ellie Sattler investigates a genetically engineered swarm of giant insects.", 6, new byte[0], "100", "Jurassic World Dominion", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 7, "A father and his two teenage daughters find themselves hunted by a massive rogue lion intent on proving that the Savanna has but one apex predator.", 7, new byte[0], "100", "Beast", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 8, "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.", 8, new byte[0], "100", "Avatar", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 9, "A bounty hunting scam joins two men in an uneasy alliance against a third in a race to find a fortune in gold buried in a remote cemetery.", 9, new byte[0], "100", "The Good, the Bad and the Ugly", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 10, "When a sadistic serial killer begins murdering key political figures in Gotham, Batman is forced to investigate the city's hidden corruption and question his family's involvement.", 10, new byte[0], "100", "The Batman", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 11, "A puppet is brought to life by a fairy, who assigns him to lead a virtuous life in order to become a real boy.", 11, new byte[0], "100", "Pinocchio", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 12, "A young woman takes a trip to romantic Verona, Italy, after a breakup, only to find that the villa she reserved was double-booked, and she'll have to share her vacation with a cynical British man.", 12, new byte[0], "100", "Love in the Villa", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 13, "In 1979, a group of young filmmakers set out to make an adult film in rural Texas, but when their reclusive, elderly hosts catch them in the act, the cast find themselves fighting for their lives.", 13, new byte[0], "100", "X", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 14, "A fictionalized chronicle of the inner life of Marilyn Monroe.", 14, new byte[0], "100", "Blonde", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 15, "From visionary director Robert Eggers comes The Northman, an action-filled epic that follows a young Viking prince on his quest to avenge his father's murder.", 15, new byte[0], "100", "The Northman", new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "UserRole",
                columns: new[] { "UserRoleID", "DateModified", "RoleID", "UserID" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 1, 1 },
                    { 2, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 2 },
                    { 3, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 3 },
                    { 4, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 4 },
                    { 5, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 5 },
                    { 6, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 6 },
                    { 7, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 7 },
                    { 8, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 8 },
                    { 9, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 9 },
                    { 10, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 10 },
                    { 11, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 11 },
                    { 12, new DateTime(2024, 1, 30, 0, 0, 0, 0, DateTimeKind.Local), 2, 12 }
                });

            migrationBuilder.InsertData(
                table: "MovieGenre",
                columns: new[] { "MovieGenreID", "GenreID", "MovieID" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 10, 1 },
                    { 3, 4, 1 },
                    { 4, 1, 2 },
                    { 5, 2, 2 },
                    { 6, 1, 3 },
                    { 7, 4, 3 },
                    { 8, 6, 3 },
                    { 9, 1, 4 },
                    { 10, 2, 4 },
                    { 11, 11, 4 },
                    { 12, 1, 5 },
                    { 13, 10, 5 },
                    { 14, 11, 5 },
                    { 15, 1, 6 },
                    { 16, 10, 6 },
                    { 17, 7, 6 },
                    { 18, 10, 7 },
                    { 19, 2, 7 },
                    { 20, 3, 7 },
                    { 21, 1, 8 },
                    { 22, 10, 8 },
                    { 23, 11, 8 },
                    { 24, 10, 9 },
                    { 25, 5, 9 },
                    { 26, 1, 10 },
                    { 27, 9, 10 },
                    { 28, 2, 10 },
                    { 29, 1, 11 },
                    { 30, 4, 11 },
                    { 31, 2, 11 },
                    { 32, 4, 12 },
                    { 33, 8, 12 },
                    { 34, 3, 13 },
                    { 35, 12, 13 },
                    { 36, 6, 13 },
                    { 37, 4, 14 },
                    { 38, 8, 14 },
                    { 39, 12, 14 },
                    { 40, 1, 15 },
                    { 41, 10, 15 },
                    { 42, 2, 15 }
                });

            migrationBuilder.InsertData(
                table: "Projection",
                columns: new[] { "ProjectionID", "AuditoriumID", "DateOfProjection", "MovieID", "TicketPrice" },
                values: new object[,]
                {
                    { 1, 2, new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified), 1, 5.00m },
                    { 2, 3, new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified), 2, 5.00m },
                    { 3, 4, new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified), 3, 5.00m },
                    { 4, 5, new DateTime(2022, 9, 13, 20, 0, 0, 0, DateTimeKind.Unspecified), 4, 5.00m }
                });

            migrationBuilder.InsertData(
                table: "Reservation",
                columns: new[] { "ReservationID", "Column", "DateOfReservation", "NumTicket", "ProjectionID", "Row", "UserID" },
                values: new object[] { 1, "1", new DateTime(2022, 9, 11, 15, 0, 0, 0, DateTimeKind.Unspecified), "2", 1, "1", 3 });

            migrationBuilder.InsertData(
                table: "Reservation",
                columns: new[] { "ReservationID", "Column", "DateOfReservation", "NumTicket", "ProjectionID", "Row", "UserID" },
                values: new object[] { 2, "1", new DateTime(2022, 9, 12, 15, 0, 0, 0, DateTimeKind.Unspecified), "2", 2, "1", 3 });

            migrationBuilder.InsertData(
                table: "Reservation",
                columns: new[] { "ReservationID", "Column", "DateOfReservation", "NumTicket", "ProjectionID", "Row", "UserID" },
                values: new object[] { 3, "1", new DateTime(2022, 9, 13, 15, 0, 0, 0, DateTimeKind.Unspecified), "1", 3, "1", 3 });

            migrationBuilder.CreateIndex(
                name: "IX_Movie_DirectorID",
                table: "Movie",
                column: "DirectorID");

            migrationBuilder.CreateIndex(
                name: "IX_MovieGenre_GenreID",
                table: "MovieGenre",
                column: "GenreID");

            migrationBuilder.CreateIndex(
                name: "IX_MovieGenre_MovieID",
                table: "MovieGenre",
                column: "MovieID");

            migrationBuilder.CreateIndex(
                name: "IX_Projection_AuditoriumID",
                table: "Projection",
                column: "AuditoriumID");

            migrationBuilder.CreateIndex(
                name: "IX_Projection_MovieID",
                table: "Projection",
                column: "MovieID");

            migrationBuilder.CreateIndex(
                name: "IX_Rating_MovieID",
                table: "Rating",
                column: "MovieID");

            migrationBuilder.CreateIndex(
                name: "IX_Rating_UserID",
                table: "Rating",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_ProjectionID",
                table: "Reservation",
                column: "ProjectionID");

            migrationBuilder.CreateIndex(
                name: "IX_Reservation_UserID",
                table: "Reservation",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_Transaction_ReservationID",
                table: "Transaction",
                column: "ReservationID");

            migrationBuilder.CreateIndex(
                name: "IX_Transaction_UserID",
                table: "Transaction",
                column: "UserID");

            migrationBuilder.CreateIndex(
                name: "IX_UserRole_RoleID",
                table: "UserRole",
                column: "RoleID");

            migrationBuilder.CreateIndex(
                name: "IX_UserRole_UserID",
                table: "UserRole",
                column: "UserID");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "IsDeleted");

            migrationBuilder.DropTable(
                name: "MovieGenre");

            migrationBuilder.DropTable(
                name: "Rating");

            migrationBuilder.DropTable(
                name: "Transaction");

            migrationBuilder.DropTable(
                name: "UserRole");

            migrationBuilder.DropTable(
                name: "Genre");

            migrationBuilder.DropTable(
                name: "Reservation");

            migrationBuilder.DropTable(
                name: "Role");

            migrationBuilder.DropTable(
                name: "Projection");

            migrationBuilder.DropTable(
                name: "User");

            migrationBuilder.DropTable(
                name: "Auditorium");

            migrationBuilder.DropTable(
                name: "Movie");

            migrationBuilder.DropTable(
                name: "Director");
        }
    }
}
