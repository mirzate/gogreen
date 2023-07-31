using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Threading.Channels;

namespace RabbitMQ.Service
{
    public class RabbitMQService
    {
        private readonly IConnection _connection;
        private readonly IModel _channel;
        private readonly IConfiguration _config;

        public RabbitMQService(IConfiguration config)
        {

            _config  = config;

            var hostName = _config["RabbitMQConfig:HostName"];
            var port = int.Parse(_config["RabbitMQConfig:Port"]);
            var userName = _config["RabbitMQConfig:UserName"];
            var password = _config["RabbitMQConfig:Password"];
            var defaultQueue = _config["RabbitMQConfig:DefaultQueue"];

            // Create the connection factory
            var factory = new ConnectionFactory
            {
                HostName = hostName,
                Port = port,
                UserName = userName,
                Password = password

            };

            // Create the connection and channel
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.QueueDeclare(queue: defaultQueue, durable: false, exclusive: false, autoDelete: false, arguments: null);
        }

        // Add methods for publishing and consuming messages, handling queues, etc.
        public void PublishMessage(string message, string queueName)
        {
            //_channel.QueueDeclare(queue: queueName, durable: false, exclusive: false, autoDelete: false, arguments: null);
            var body = Encoding.UTF8.GetBytes(message);
            _channel.BasicPublish(exchange: "", routingKey: queueName, basicProperties: null, body: body);
        }

        // Dispose the connection and channel when the service is no longer needed
        public void Dispose()
        {
            _channel?.Dispose();
            _connection?.Dispose();
        }

        public void SubscribeToMessages(string queueName, Action<string> callback)
        {
            // Declare the queue if it doesn't already exist
            _channel.QueueDeclare(queue: queueName, durable: false, exclusive: false, autoDelete: false, arguments: null);

            // Create a consumer and start consuming messages
            var consumer = new EventingBasicConsumer(_channel);
            consumer.Received += (sender, args) =>
            {
                var message = Encoding.UTF8.GetString(args.Body.ToArray());

                // Invoke the callback with the received message
                callback.Invoke(message);
            };

            _channel.BasicConsume(queue: queueName, autoAck: true, consumer: consumer);
        }

        public string ConsumeMessage(string queueName)
        {
            //_channel.QueueDeclare(queue: queueName, durable: false, exclusive: false, autoDelete: false, arguments: null);
            var result = _channel.BasicGet(queueName, autoAck: true);

            if (result != null)
            {
                var body = result.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);

                // Manually acknowledge the message after processing
                //_channel.BasicAck(result.DeliveryTag, false);

                return message;
            }

            return null;
        }

        public List<string> ReadAllMessagesFromQueue(string queueName)
        {
            var receivedMessages = new List<string>();

            while (true)
            {
                var message = ConsumeMessage(queueName);
               //Console.WriteLine($"Received message: {message}");
                if (message == null)
                {
                    break; // Queue is empty, break the loop
                }

                receivedMessages.Add(message);

            }

            return receivedMessages;
        }

        public void PublishStatusChangeEvent(string status, int ecoViolationId)
        {
            // Create a message payload with the status and ecoViolationId
            var messagePayload = new { Status = status, EcoViolationId = ecoViolationId };
            var message = JsonConvert.SerializeObject(messagePayload);

            // Publish the message to the RabbitMQ queue
            PublishMessage(message, "status_change_queue");
        }

    }
}
