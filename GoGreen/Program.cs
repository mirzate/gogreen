using GoGreen;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;


var builder = WebApplication.CreateBuilder(args);


var startup = new Startup(builder.Configuration, builder.Environment);
//var startup = new Startup(builder.Configuration);
startup.ConfigureServicesAsync(builder.Services); // calling ConfigureServices method


var app = builder.Build();


startup.Configure(app);


