using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SafeHarbor.Data;
using SafeHarbor.Models.Entities;

namespace SafeHarbor.Controllers.Admin
{
    [Route("api/admin/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")] // Mandatory for SafeHarbor security specs
    public class ContributionsController : ControllerBase
    {
        private readonly SafeHarborDbContext _context;

        public ContributionsController(SafeHarborDbContext context)
        {
            _context = context;
        }

        // 1. READ: Get all contributions
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Contribution>>> GetContributions()
        {
            return await _context.Contributions
                .OrderByDescending(c => c.ContributionDate)
                .ToListAsync();
        }

        // 2. UPDATE: Edit an existing contribution
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateContribution(Guid id, Contribution contribution)
        {
            // Security check: ID in URL must match the object ID
            if (id != contribution.Id)
            {
                return BadRequest("Record ID mismatch.");
            }

            // Mark the entity as modified so EF knows to push an UPDATE to SQL
            _context.Entry(contribution).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ContributionExists(id))
                {
                    return NotFound();
                }
                throw;
            }

            return NoContent(); // Success (204)
        }

        // 3. DELETE: Remove a record
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteContribution(Guid id)
        {
            var contribution = await _context.Contributions.FindAsync(id);
            if (contribution == null)
            {
                return NotFound();
            }

            _context.Contributions.Remove(contribution);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ContributionExists(Guid id)
        {
            return _context.Contributions.Any(e => e.Id == id);
        }
    }
}