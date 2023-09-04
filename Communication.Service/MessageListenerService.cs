using System;
using System.Text;
using Microsoft.Extensions.Configuration;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Net.Http;
using System.Collections.Generic;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Xamarin.Essentials;
using RabbitMQ.Client.Exceptions;
using Polly;

namespace Communication.Service
{
    public class MessageListenerService
    {
        private readonly IConfiguration _config;
        private IModel _channel;
        private readonly EmailService _emailService;

        public MessageListenerService(IConfiguration config, EmailService emailService)
        {
            Console.WriteLine("################# MessageListenerService ###########");

            _config = config;
            _emailService = emailService;
            var defaultQueue = "status_change_queue";
            Console.WriteLine($"RabbitMQConfig-Hostname: {_config["RabbitMQConfig:HostName"]}");

            var retryPolicy = Policy
                            .Handle<BrokerUnreachableException>() // Customize with other exceptions if needed
                            .WaitAndRetry(10, retryAttempt => TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)));
                            //.WaitAndRetry(100, retryAttempt => TimeSpan.FromSeconds(2));
            // Use the retry policy to establish a connection to RabbitMQ
            retryPolicy.Execute(() =>
            {
                try
                {

                    var factory = new ConnectionFactory()
                    {
                        HostName = _config["RabbitMQConfig:HostName"],
                        Port = int.Parse(_config["RabbitMQConfig:Port"]),
                        UserName = _config["RabbitMQConfig:UserName"],
                        Password = _config["RabbitMQConfig:Password"],
                    };

                    var connection = factory.CreateConnection();
                    _channel = connection.CreateModel();

                    _channel.QueueDeclare(queue: defaultQueue, durable: false, exclusive: false, autoDelete: false, arguments: null);

                    var consumer = new EventingBasicConsumer(_channel);
                    consumer.Received += async (model, ea) =>
                    {
                        var body = ea.Body.ToArray();
                        var message = Encoding.UTF8.GetString(body);

                        // Process the received message and send the email
                        await ProcessAndSendEmail(message);
                    };

                    _channel.BasicConsume(queue: defaultQueue, autoAck: true, consumer: consumer);
                    
                    Console.WriteLine($"RabbitMQ connection successful");

                }
                catch (BrokerUnreachableException ex)
                {
                    Console.WriteLine($"RabbitMQ connection failed: {ex.Message} - Communication will be re-established >>> ...");
                    throw; // Re-throw the exception to trigger the retry
                }
            });
        }

        public class EcoViolationMessage
        {
            public string Title { get; set; }
            public string Response { get; set; }
            public string Status { get; set; }
            public string Contact { get; set; }
        }


        private async Task ProcessAndSendEmail(string message)
        {
            // You need to parse the message content to extract email, subject, and message details.
            // For example, you can use JSON serialization or any other format that suits your needs.

            // Example JSON format: {"email": "recipient@example.com", "subject": "Email Subject", "message": "Email Message"}
            // Deserialize the JSON message into an object

            try
            {
                // Parse the message JSON here
                var emailMessage = JsonConvert.DeserializeObject<EcoViolationMessage>(message);

                string email = emailMessage.Contact;
                string title = emailMessage.Title;
                string status = emailMessage.Status;

                Console.WriteLine($"Email: {email}");
                Console.WriteLine($"title: {title}");
                Console.WriteLine($"status: {status}");
                Console.WriteLine($"message: {message}");

                if (!string.IsNullOrEmpty(email))
                {
                    string subject = "Message Received from GoGreen (ecoViolation) via RabbitMQ | " + title + " | " + status;
                    _emailService.SendEmailAsync(email, subject, message);
                }
                Console.WriteLine("Email sent successfully!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing and sending email: {ex.Message}");
            }
        }
    }
}
