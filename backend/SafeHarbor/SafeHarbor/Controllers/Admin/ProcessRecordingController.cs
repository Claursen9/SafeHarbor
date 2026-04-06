using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SafeHarbor.DTOs;

namespace SafeHarbor.Controllers.Admin;

[ApiController]
[Route("api/admin/process-recordings")]
[Authorize]
public sealed class ProcessRecordingController : ControllerBase
{
    [HttpGet]
    public ActionResult<PagedResult<ProcessRecordItem>> GetByResidentCase([FromQuery] Guid residentCaseId, [FromQuery] PagingQuery query)
    {
        // TODO: Fetch process recordings from ICaseNarrativeStore when persistence is available.
        // residentCaseId is intentionally kept in the contract so front-end integration does not change later.
        _ = residentCaseId;
        return Ok(new PagedResult<ProcessRecordItem>(Array.Empty<ProcessRecordItem>(), query.NormalizedPage, query.NormalizedPageSize, 0));
    }

    [HttpPost]
    [Authorize(Roles = "SocialWorker")]
    public ActionResult<ProcessRecordItem> Create([FromBody] CreateProcessRecordRequest _)
    {
        return StatusCode(StatusCodes.Status501NotImplemented, "Process recording writes require database integration.");
    }

    [HttpPut("{id:guid}")]
    [Authorize(Roles = "SocialWorker")]
    public ActionResult<ProcessRecordItem> Update(Guid id, [FromBody] CreateProcessRecordRequest _)
    {
        return StatusCode(StatusCodes.Status501NotImplemented, $"Process record {id} cannot be updated until database integration is complete.");
    }

    [HttpDelete("{id:guid}")]
    [Authorize(Roles = "SocialWorker")]
    public IActionResult Delete(Guid id)
    {
        return StatusCode(StatusCodes.Status501NotImplemented, $"Process record {id} cannot be deleted until database integration is complete.");
    }
}
