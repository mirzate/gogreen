
using GoGreen.Models;
using GoGreen.Data;
using GoGreen.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Reflection;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using RabbitMQ.Service;
using System.Threading.Channels;
using Microsoft.Extensions.Options;
using GoGreen.Mappings;
using AutoMapper;
using System.Linq;
using Microsoft.Extensions.Hosting.Internal;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Controllers;
using GoGreen.Controllers;
using System;
using Microsoft.Extensions.Hosting;
using GoGreen.Data.Seeders;

namespace GoGreen
{
    public class Startup
    {

        public IConfiguration Configuration { get; }
        public IWebHostEnvironment Environment { get; }    

        public Startup(IConfiguration configuration, IWebHostEnvironment environment)
        {
            //Configuration  = configuration;


            Configuration = new ConfigurationBuilder()
                .SetBasePath(environment.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{environment.EnvironmentName}.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
            .Build();

            Environment = environment;

            Console.WriteLine($"AzureStorage__ConnectionString: {Configuration["AzureStorage:ConnectionString"]}");


        }
        public async Task ConfigureServicesAsync(IServiceCollection services)
        {
            /*
            var config = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json", false)
            .Build();

            */
            // Add AutoMapper
            services.AddAutoMapper(typeof(MappingProfile));

            /*
            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlServer(config.GetConnectionString("DefaultConnection")));
            */
            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));


            services.AddIdentity<User, IdentityRole>()
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddDefaultTokenProviders();

            services.AddScoped<DataSeeder>();
           
            services.AddScoped<IAuthenticationService, AuthenticationService>();
            services.AddScoped<RabbitMQService>();
            services.AddScoped<IEventService, EventService>();
            services.AddScoped<IEcoViolationService, EcoViolationService>();
            services.AddScoped<IGreenIslandService, GreenIslandService>();
            services.AddScoped<IImageService, ImageService>();
            services.AddScoped<CustomExceptionHandler>();


            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(o =>
            {
                o.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidIssuer = Configuration["Jwt:Issuer"],
                    ValidAudience = Configuration["Jwt:Audience"],
                    IssuerSigningKey = new SymmetricSecurityKey
                    (Encoding.UTF8.GetBytes(Configuration["Jwt:Key"])),
                    ValidateIssuer = true,
                    ValidateAudience = true,
                    ValidateLifetime = false,
                    ValidateIssuerSigningKey = true
                };
            });

            services.AddAuthorization();

            services.Configure<IdentityOptions>(options =>
            {
                // Disable password requirements for seeding
                options.Password.RequireDigit = false;
                options.Password.RequireLowercase = false;
                options.Password.RequireUppercase = false;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequiredLength = 1; // Set the minimum required password length to 1 or any desired value
            });

            /* 
            services.AddControllers(options =>
            {
                options.Filters.Add<CustomExceptionHandler>(); // Add globally
            });
            */
            services.AddControllers();

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            services.AddEndpointsApiExplorer();

            services.AddSwaggerGen(c =>
            {


                c.SwaggerDoc("v1", new OpenApiInfo { Title = "GoGreen API", Version = "v1" });

                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Description = "JWT Authorization header using the Bearer scheme. Example: \"Authorization: Bearer {token}\"",
                    Name = "Authorization",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer"
                });
                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            },
                            Scheme = "oauth2",
                            Name = "Bearer",
                            In = ParameterLocation.Header,
                        },
                        new List<string>()
                    }
                });
                c.OperationFilter<FileUploadOperationFilter>();
            });


            // Add automatic database migration
            using (var serviceProvider = services.BuildServiceProvider())
            {
                using (var scope = serviceProvider.CreateScope())
                {
                    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
                    dbContext.Database.Migrate();

                    var userManager = scope.ServiceProvider.GetRequiredService<UserManager<User>>();
                    await UserSeeder.SeedUsers(userManager);

                    //var dataSeeder = scope.ServiceProvider.GetRequiredService<DataSeeder>();
                   //dataSeeder.SeedData().Wait();

                    await MunicipalitySeeder.SeedMunicipalities(dbContext);
                    await EventTypeSeeder.SeedEventTypes(dbContext);
                    await EcoViolationStatusSeeder.SeedEcoViolationStatuses(serviceProvider);
                    await EventSeeder.SeedEvents(serviceProvider);
                    await EcoViolationSeeder.SeedEcoViolations(serviceProvider);
                    await GreenIslandSeeder.SeedGreenIslands(serviceProvider);
                    await ImageSeeder.SeedImages(serviceProvider);

                }
            }

            services.AddCors(options =>
            {
                options.AddPolicy("AllowAll",
                    builder =>
                    {
                        builder.AllowAnyOrigin()
                               .AllowAnyMethod()
                               .AllowAnyHeader();
                    });
            });



        }

        public void Configure(WebApplication app)
        {

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment() || app.Environment.EnvironmentName == "Production")
            {
            }
                app.UseSwagger();
                app.UseSwaggerUI(c =>
                {
                    c.SwaggerEndpoint("/swagger/v1/swagger.json", "GoGreen");
                });
            
            app.UseStaticFiles();

            app.UseHttpsRedirection();

            app.UseAuthentication();

            app.UseAuthorization();

            app.MapControllers();

            app.UseCors("AllowAll");

            app.Run();


        }


        public class FileUploadOperationFilter : IOperationFilter
        {
            public void Apply(OpenApiOperation operation, OperationFilterContext context)
            {
                var apiDescription = context.ApiDescription;

                if (apiDescription.ActionDescriptor is ControllerActionDescriptor controllerActionDescriptor)
                {
               
                        if (apiDescription.ParameterDescriptions.Any(x => x.ModelMetadata != null && x.ModelMetadata.ContainerType == typeof(IFormFile)))
                        {
                            operation.Parameters.Add(new OpenApiParameter
                            {
                                Name = "imageFile",
                                In = ParameterLocation.Header,
                                Description = "Image file",
                                Required = true,
                                Schema = new OpenApiSchema
                                {
                                    Type = "file",
                                    Format = "binary"
                                }
                            });
                        }
                    
                }
            }

        }

        }

}
