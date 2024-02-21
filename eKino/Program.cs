using System.Net;
using eKino;
using eKino.Filters;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;
using eKino.Services.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.

//builder.Services.AddTransient<IMoviesServices, MoviesServices>();
//builder.Services.AddTransient<IUserService, UserService>();
//builder.Services.AddTransient<IDirectorService, DirectorService>();

builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IAuditoriumService, AuditoriumService>();
builder.Services.AddTransient<IDirectorService, DirectorService>();
builder.Services.AddTransient<IGenreService, GenreService>();
builder.Services.AddTransient<IMoviesServices, MoviesServices>();
builder.Services.AddTransient<IProjectionService, ProjectionService>();
builder.Services.AddTransient<IRatingService, RatingService>();
builder.Services.AddTransient<IReservationService, ReservationService>();
builder.Services.AddTransient<ITransactionService, TransactionService>();
builder.Services.AddTransient<IRoleService, RoleService>();


builder.Services.AddAutoMapper(typeof(IUserService));
builder.Services.AddAutoMapper(typeof(IAuditoriumService));
builder.Services.AddAutoMapper(typeof(IDirectorService));
builder.Services.AddAutoMapper(typeof(IGenreService));
builder.Services.AddAutoMapper(typeof(IMoviesServices));
builder.Services.AddAutoMapper(typeof(IProjectionService));
builder.Services.AddAutoMapper(typeof(IRatingService));
builder.Services.AddAutoMapper(typeof(IReservationService));
builder.Services.AddAutoMapper(typeof(ITransactionService));
builder.Services.AddAutoMapper(typeof(ITransactionService));
builder.Services.AddAutoMapper(typeof(IRoleService));

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[]{}
        }
    });
});


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<eKinoContext>(options =>
options.UseSqlServer(connectionString));
 
// builder.Services.AddDbContext<eKinoContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddAutoMapper(typeof(IUserService));

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();


app.UseAuthentication();
app.UseAuthorization();


app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<eKinoContext>();

    dataContext.Database.Migrate();
}

app.Run();