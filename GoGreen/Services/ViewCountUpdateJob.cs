using System;
using System.Threading;
using System.Threading.Tasks;
using GoGreen.Data;
using GoGreen.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using Bogus;
using GoGreen.Models;

public class ViewCountUpdateJob<T> : BackgroundService where T : class, IViewCountable
{
    private readonly IServiceProvider _services;
    private readonly int _updateIntervalSeconds;

    public ViewCountUpdateJob(IServiceProvider services, int updateIntervalSeconds = 30)
    {
        _services = services;
        _updateIntervalSeconds = updateIntervalSeconds;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {


        while (!stoppingToken.IsCancellationRequested)
        {
            // Get the service scope
            using (var scope = _services.CreateScope())
            {
                var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

                var datas = dbContext.Set<T>().ToList();


                if (datas.Count > 0)
                {

                    int randomIndex = new Random().Next(0, datas.Count);
                    int randomId = datas[randomIndex].Id;

                    var modelToUpdate = dbContext.Find<T>(randomId);

                    if (modelToUpdate != null)
                    {
   

                            if (modelToUpdate.ViewCount == null)
                            {
                                modelToUpdate.ViewCount = 1;
                            }
                            else
                            {
                                modelToUpdate.ViewCount += 1;
                            }
                            dbContext.SaveChanges();


                            if (typeof(Event) == typeof(T))
                            {

                                // Random users
                                var users = dbContext.User.ToList();

                                if (users.Count > 0)
                                {
                                    int randomUserIndex = new Random().Next(0, users.Count);
                                    string randomUserId = users[randomUserIndex].Id;
                                
                                    var eventSubscribe = new EventSubscribe();
                                    eventSubscribe.SubscribeDate = DateTime.Now;
                                    eventSubscribe.UserId = randomUserId; // dbContext.User.First().Id;
                                    eventSubscribe.EventId = randomId;

                                    dbContext.EventSubscribes.Add(eventSubscribe);
                                    dbContext.SaveChangesAsync();
                                }

                                


                            }

                    }
                }

                await Task.Delay(TimeSpan.FromSeconds(_updateIntervalSeconds), stoppingToken);
            }
        }
    }
}

