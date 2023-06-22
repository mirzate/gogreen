using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using System;

public class CustomExceptionHandler : ControllerBase, IExceptionFilter
{
    private readonly ILogger<CustomExceptionHandler> _logger;

    public CustomExceptionHandler(ILogger<CustomExceptionHandler> logger)
    {
        _logger = logger;
    }

    public void OnException(ExceptionContext context)
    {
        // Log the exception
        _logger.LogError(context.Exception, "An unhandled exception occurred.");

        if (context.Exception is NotImplementedException)
        {
            // Handle NotImplementedException differently
            context.Result = new ObjectResult("Not implemented.")
            {
                StatusCode = 501 // Set the desired HTTP status code for NotImplementedException
            };

            // Log the exception or perform other custom actions
            _logger.LogWarning(context.Exception, "Not implemented exception occurred.");
        }

        // Prevent the exception from being re-thrown
        context.ExceptionHandled = true;
    }
}
