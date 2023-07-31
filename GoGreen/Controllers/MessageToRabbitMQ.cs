using GoGreen.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Service;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class MessageToRabbitMQ : ControllerBase
    {

        private readonly ApplicationDbContext _dbContext;
        private readonly RabbitMQService _rabbitMQService;


        public MessageToRabbitMQ(ApplicationDbContext dbContext, RabbitMQService rabbitMQService)
        {
            _dbContext = dbContext;
            _rabbitMQService = rabbitMQService;
        }

        [AllowAnonymous]
        [HttpGet("/ReadAllMessagesFromQueue")]
        public IActionResult GetAllMessagesFromQueue(string queueName = "my_queue")
        {

            var receivedMessages = _rabbitMQService.ReadAllMessagesFromQueue(queueName);

            if (receivedMessages.Count > 0)
            {
                return Ok(receivedMessages);
            }
            else
            {
                return NotFound();
            }
        }



        // get: api/Message
        [AllowAnonymous]
        [HttpGet("/EcoViolation")]
        public IActionResult getEcoViolationMessages()
        {

             

            var queueName = "status_change_queue";

            return this.GetAllMessagesFromQueue(queueName);
            /*
            string receivedMessage = null;

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
            */

        }

        // POST: api/Message
        [AllowAnonymous]
        [HttpPost]
        public IActionResult PostMessageAsync(string message = "My new message", string queueName = "my_queue")
        {

            // Call the PublishMessage method as needed
            //var message = "Hello, RabbitMQ!";
            //var queueName = "my_queue";

            //string receivedMessage = null;
            List<string> receivedMessage;

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
            //receivedMessage = _rabbitMQService.ConsumeMessage(queueName);
            //var receivedMessages = _rabbitMQService.ReadAllMessagesFromQueue(queueName);

            return Ok("Posted");
            /*
            _rabbitMQService.Dispose();

            if (receivedMessages.Count > 0)
            {
                return Ok(receivedMessages);
            }
            else
            {
                return NotFound("No messages found in the queue.");
            }
            */
        }



    }
}
