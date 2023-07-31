using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace Communication.Service
{
    public class EmailService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public EmailService(IConfiguration config)
        {
            _config  = config;

            var apiKey = _config["Mailgun:apiKey"] ?? "";
            var domain = _config["Mailgun:domain"] ?? "";

            //Console.WriteLine("SendEmailAsync domain..." + domain);

            _httpClient = new HttpClient
            {
                BaseAddress = new Uri($"https://api.mailgun.net/v3/{domain}/")
            };

            // Set the authorization header with the API key
            _httpClient.DefaultRequestHeaders.Authorization =
                new System.Net.Http.Headers.AuthenticationHeaderValue("Basic",
                    Convert.ToBase64String(Encoding.ASCII.GetBytes($"api:{apiKey}")));
        }

        public async Task SendEmailAsync(string email, string subject, string message)
        {
            Console.WriteLine("SendEmailAsync...");
            var content = new FormUrlEncodedContent(new[]
            {
                new KeyValuePair<string, string>("from", "GoGreen - FIT <noreplay@2andthree.com>"),
                new KeyValuePair<string, string>("to", email),
                new KeyValuePair<string, string>("subject", subject),
                new KeyValuePair<string, string>("text", message)
            });

            try
            {
                var response = await _httpClient.PostAsync($"messages", content);
                response.EnsureSuccessStatusCode();
                Console.WriteLine("Email sent successfully!");
            }
            catch (HttpRequestException ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }
    }
}
