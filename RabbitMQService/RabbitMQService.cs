using Microsoft.Extensions.Configuration;
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

            // Create the connection factory
            var factory = new ConnectionFactory
            {
                HostName = _config["RabbitMQ:HostName"],
                Port = int.Parse(_config["RabbitMQ:Port"]),
                UserName = _config["RabbitMQ:UserName"],
                Password = _config["RabbitMQ:Password"]
            };

            // Create the connection and channel
            _connection = factory.CreateConnection();
            _channel = _connection.CreateModel();
            _channel.QueueDeclare(queue: _config["RabbitMQ:DefaultQueue"], durable: false, exclusive: false, autoDelete: false, arguments: null);
        }

        // Add methods for publishing and consuming messages, handling queues, etc.
        public void PublishMessage(string message, string queueName)
        {
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
            var result = _channel.BasicGet(queueName, autoAck: true);

            if (result != null)
            {
                var body = result.Body.ToArray();
                var message = Encoding.UTF8.GetString(body);
                return message;
            }

            return null;
        }

    }
}
