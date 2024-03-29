﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GoGreen.Models;
using GoGreen.Data;
using GoGreen.Requests;
using System.Net;
using Azure.Core;
using GoGreen.Services;
using GoGreen.Responses;
using Microsoft.AspNetCore.Authorization;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventTypeController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public EventTypeController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/EventType
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EventType>>> GetEventTypes()
        {
            return await _context.EventTypes.ToListAsync();
        }

        // GET: api/EventType/5
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<ActionResult<EventType>> GetEventType(int id)
        {
            var eventType = await _context.EventTypes
                .FirstOrDefaultAsync(m => m.Id == id);

            if (eventType == null)
            {
                return NotFound();
            }

            return eventType;
        }

        // POST: api/EventType
        [Authorize(Roles = "super-admin")]
        [HttpPost]
        public async Task<ActionResult<EventType>> PostEventType([FromBody] EventTypeRequest request)
        {

            var eventType = new EventType
            {
                Name = request.Name
            };

            _context.EventTypes.Add(eventType);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetEventType), new { id = eventType.Id }, eventType);
        }

        // PUT: api/EventType/5
        [Authorize(Roles = "super-admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutEventType(int id, [FromBody] EventTypeRequest request)
        {

            var existingData = await _context.EventTypes.FindAsync(id);

            if (existingData == null)
            {
                return NotFound();
            }

            existingData.Name = request.Name;

            /*
            if (id != eventType.Id)
            {
                return BadRequest();
            }

            _context.Entry(eventType).State = EntityState.Modified;
            */
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EventTypeExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // DELETE: api/EventType/5
        [Authorize(Roles = "super-admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEventType(int id)
        {
            var eventType = await _context.EventTypes.FindAsync(id);
            if (eventType == null)
            {
                return NotFound();
            }

            _context.EventTypes.Remove(eventType);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool EventTypeExists(int id)
        {
            return _context.EventTypes.Any(m => m.Id == id);
        }
    }
}
