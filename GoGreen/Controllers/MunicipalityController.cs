using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GoGreen.Models;
using GoGreen.Data;
using GoGreen.Requests;
using System.Net;
using Microsoft.AspNetCore.Authorization;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class MunicipalityController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public MunicipalityController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/Municipality
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Municipality>>> GetMunicipalities()
        {
            return await _context.Municipalities.ToListAsync();
        }

        // GET: api/Municipality/5
        [AllowAnonymous]
        [HttpGet("{id}")]
        public async Task<ActionResult<Municipality>> GetMunicipality(int id)
        {
            var municipality = await _context.Municipalities
                .FirstOrDefaultAsync(m => m.Id == id);

            if (municipality == null)
            {
                return NotFound();
            }

            return municipality;
        }

        // POST: api/Municipality
        [Authorize(Roles = "super-admin")]
        [HttpPost]
        public async Task<ActionResult<Municipality>> PostMunicipality([FromBody] MunicipalityRequest request)
        {

            var municipality = new Municipality
            {
                Title = request.Title,
                Description = request.Description,
                Active = request.Active
            };

            _context.Municipalities.Add(municipality);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetMunicipality), new { id = municipality.Id }, municipality);
        }

        // PUT: api/Municipality/5
        [Authorize(Roles = "super-admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutMunicipality(int id, Municipality municipality)
        {
            if (id != municipality.Id)
            {
                return BadRequest();
            }

            _context.Entry(municipality).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!MunicipalityExists(id))
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

        // DELETE: api/Municipality/5
        [Authorize(Roles = "super-admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMunicipality(int id)
        {
            var municipality = await _context.Municipalities.FindAsync(id);
            if (municipality == null)
            {
                return NotFound();
            }

            _context.Municipalities.Remove(municipality);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool MunicipalityExists(int id)
        {
            return _context.Municipalities.Any(m => m.Id == id);
        }
    }
}
