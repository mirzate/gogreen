using GoGreen.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Service;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class SendMessageToRabbitMQ : ControllerBase
    {

        private readonly ApplicationDbContext _dbContext;
        private readonly RabbitMQService _rabbitMQService;


        public SendMessageToRabbitMQ(ApplicationDbContext dbContext, RabbitMQService rabbitMQService)
        {
            _dbContext = dbContext;
            _rabbitMQService = rabbitMQService;
        }

        // POST: api/Message
        [AllowAnonymous]
        [HttpPost]
        public IActionResult PostMessage()
        {

            // Call the PublishMessage method as needed
            var message = "Hello, RabbitMQ!";
            var queueName = "my_queue";

            string receivedMessage = null;
     
            _rabbitMQService.PublishMessage(message, queueName);

            
            /*
            // Subscribe to messages and set the received message in the callback
            _rabbitMQService.SubscribeToMessages(queueName, message =>
            {
                receivedMessage = message;
                Console.WriteLine($"Received message: {receivedMessage}");
            });
            */

            // Consume a message from RabbitMQ
            receivedMessage = _rabbitMQService.ConsumeMessage(queueName);


            _rabbitMQService.Dispose();

            if (receivedMessage != null)
            {
                return Ok(receivedMessage);
            }
            else
            {
                return NotFound();
            }

        }



    }
}
