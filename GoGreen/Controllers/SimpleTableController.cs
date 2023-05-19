using GoGreen.Data;
using GoGreen.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace GoGreen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize]

    public class SimpleTableController : ControllerBase
    {

        private readonly ApplicationDbContext _dbContext;

        public SimpleTableController(ApplicationDbContext dbContext)
        {
            this._dbContext = dbContext;
        }

        // GET: api/SimpleTable
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SimpleTable>>> GetSimpleTable()
        {
            if(_dbContext.SimpeTables == null)
            {
                return NotFound();
            }
            return await _dbContext.SimpeTables.ToArrayAsync();
        }

        // GET: api/SimpleTable/2
        [HttpGet("{id}")]
        public async Task<ActionResult<SimpleTable>> GetSimpleTable(int id)
        {
            if (_dbContext.SimpeTables == null)
            {
                return NotFound();
            }
            var data = await _dbContext.SimpeTables.FindAsync(id);
            if(data == null)
            {
                return NotFound();
            }
            return data;
        }

        // POST: api/SimpleTable
        [HttpPost]
        public async Task<ActionResult<SimpleTable>> PostSimpleTable(SimpleTable simpleTable)
        {
            _dbContext.SimpeTables.Add(simpleTable);
            await _dbContext.SaveChangesAsync();
            return CreatedAtAction(nameof(GetSimpleTable), new { id = simpleTable.Id }, simpleTable);
        }



        // PUT: api/SimpleTable/2
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSimpleTable(int id, SimpleTable simpleTable)
        {
            if (id != simpleTable.Id)
            {
                return BadRequest();
            }

            _dbContext.Entry(simpleTable).State = EntityState.Modified;

            try
            {
                await _dbContext.SaveChangesAsync();
            }
            catch (DBConcurrencyException)
            {
                if (!SimpleTableDataExist(id))
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

        private bool SimpleTableDataExist(long id)
        {
            return (_dbContext.SimpeTables?.Any(e => e.Id == id)).GetValueOrDefault();
        }

        // DELETE: api/SimpleTable/2
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSimpleTable(int id)
        {
            if (_dbContext.SimpeTables == null)
            {
                return NotFound();
            }
            var simpleTable = await _dbContext.SimpeTables.FindAsync(id);
            if (simpleTable == null)
            {
                return NotFound();
            }

            _dbContext.SimpeTables.Remove(simpleTable);
            await _dbContext.SaveChangesAsync();

            return NoContent();
        }



    }
}
