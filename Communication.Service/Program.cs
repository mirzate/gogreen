using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;

namespace Communication.Service
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("### Communication.Service");

            /*
            string serviceProjectDirectory = AppContext.BaseDirectory;
            Console.WriteLine("serviceProjectDirectory" + serviceProjectDirectory);
            string solutionDirectory = Directory.GetParent(serviceProjectDirectory).FullName;
            Console.WriteLine("solutionDirectory" + solutionDirectory);
            //string goGreenDirectory = Path.Combine(solutionDirectory, "GoGreen");
            //string goGreenDirectory = @"C:\dev\fit\gg-01\GoGreen";
            string goGreenDirectory = Path.GetDirectoryName(AppDomain.CurrentDomain.BaseDirectory);
            Console.WriteLine("goGreenDirectory" + goGreenDirectory);
            */
            string environmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";
            Console.WriteLine("environmentName" + environmentName);
            // Build configuration from appsettings.json
            var configuration = new ConfigurationBuilder()
                //.SetBasePath(goGreenDirectory)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                //.AddJsonFile("appsettings.Communication.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{environmentName}.json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables()
                .Build();

            var serviceProvider = new ServiceCollection()
                .AddSingleton<IConfiguration>(configuration)
                .AddSingleton<EmailService>() // Add your EmailService here
                .AddSingleton<MessageListenerService>() // Add your MessageListenerService here
                .BuildServiceProvider();


            // Start the message listener service
            var messageListener = serviceProvider.GetService<MessageListenerService>();

            while (true)
            {
                // Your application logic here
            }
        }
    }
}
