//using Communication.Service;
using GoGreen.Data;
using GoGreen.Requests;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NJsonSchema;
using RabbitMQ.Service;
using System.Text.Json;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class MessageToRabbitMQ : ControllerBase
    {

        private readonly ApplicationDbContext _dbContext;
        private readonly RabbitMQService _rabbitMQService;
       // private readonly EmailService _emailService;

        public MessageToRabbitMQ(ApplicationDbContext dbContext, RabbitMQService rabbitMQService /*,EmailService emailService*/)
        {
            _dbContext = dbContext;
            _rabbitMQService = rabbitMQService;
           // _emailService=emailService;
        }

        [Authorize(Roles = "super-admin")]
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
        [Authorize(Roles = "super-admin")]
        [HttpGet("/ReadAllMessagesFromQueue/EcoViolation")]
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
        [Authorize(Roles = "super-admin")]
        [HttpPost]
        public IActionResult PostMessageAsync(string message = "My new message", string queueName = "my_queue")
        {

            List<string> receivedMessage;

            _rabbitMQService.PublishMessage(message, queueName);

            return Ok("Posted");

        }
        [Authorize(Roles = "super-admin")]
        [HttpPost("subscribe")]
        public IActionResult SubscribeToQueue(string queueName = "status_change_queue")
        {
            return Ok("? Subscribed to RabbitMQ channel successfully.");
            // KOmunikacija sa MQ prebacena direktno sa Communication.Servica
            /*
                 try
                 {
                     // Define the callback function to handle received messages
                     void HandleMessage(string message)
                     {

                         var ecoViolationMessage = JsonSerializer.Deserialize<EcoViolationMessage>(message);

                         string email = ecoViolationMessage.Contact;
                         string title = ecoViolationMessage.Title;
                         string status = ecoViolationMessage.Status;

                         if (!string.IsNullOrEmpty(email))
                         {
                             string subject = "Message Received from GoGreen (ecoViolation) via RabbitMQ | " + title + " | " + status;
                             _emailService.SendEmailAsync(email, subject, message);
                         }
                     }

                     // Subscribe to messages and set the received message in the callback
                     _rabbitMQService.SubscribeToMessages(queueName, HandleMessage);

                     return Ok("Subscribed to RabbitMQ channel successfully.");
                 }
                 catch (Exception ex)
                 {
                     // Handle any exception that may occur during message subscription
                     // You can log the error or take any other appropriate action
                     return StatusCode(500, "An error occurred while subscribing to RabbitMQ channel.");
                 }
            */

        }


    }
}
