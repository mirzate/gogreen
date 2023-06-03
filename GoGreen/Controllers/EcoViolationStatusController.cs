using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GoGreen.Models;
using GoGreen.Data;
using GoGreen.Requests;
using System.Net;
using Azure.Core;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EcoViolationStatusController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public EcoViolationStatusController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/EcoViolationStatus
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EcoViolationStatus>>> Index()
        {
            return await _context.EcoViolationStatuses.ToListAsync();
        }

        // GET: api/EcoViolationStatus/5
        [HttpGet("{id}")]
        public async Task<ActionResult<EcoViolationStatus>> Get(int id)
        {
            var data = await _context.EcoViolationStatuses
                .FirstOrDefaultAsync(m => m.Id == id);

            if (data == null)
            {
                return NotFound();
            }

            return data;
        }

        // POST: api/EcoViolationStatus
        [HttpPost]
        public async Task<ActionResult<EcoViolationStatus>> Store([FromBody] EcoViolationStatusRequest request)
        {

            var data = new EcoViolationStatus
            {
                Name = request.Name
            };

            _context.EcoViolationStatuses.Add(data);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(Get), new { id = data.Id }, data);
        }

        // PUT: api/EcoViolationStatus/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, [FromBody] EcoViolationStatusRequest request)
        {
            var existingData = await _context.EcoViolationStatuses.FindAsync(id);

            if (existingData == null)
            {
                return NotFound();
            }

            existingData.Name = request.Name;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!DataExists(id))
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

        // DELETE: api/EcoViolationStatus/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var data = await _context.EcoViolationStatuses.FindAsync(id);
            if (data == null)
            {
                return NotFound();
            }

            _context.EcoViolationStatuses.Remove(data);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool DataExists(int id)
        {
            return _context.EcoViolationStatuses.Any(m => m.Id == id);
        }
    }
}
