using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Json;
using System.Security.Claims;

namespace SafeHarbor.Tests;

public sealed class LocalAuthIntegrationTests : IClassFixture<SafeHarborApiFactory>
{
    private readonly SafeHarborApiFactory _factory;

    public LocalAuthIntegrationTests(SafeHarborApiFactory factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task LocalLogin_DonorUserToken_ContainsDonorRoleAcrossSupportedClaimTypes()
    {
        using var client = _factory.CreateClient();

        var response = await client.PostAsJsonAsync(
            "/api/auth/local-login",
            new { email = "alice@example.com", role = "Donor", password = "Password123!" });

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var payload = await response.Content.ReadFromJsonAsync<LocalLoginEnvelope>();
        Assert.NotNull(payload);

        var token = new JwtSecurityTokenHandler().ReadJwtToken(payload!.IdToken);
        var roleValues = token.Claims.Where(c =>
                c.Type == ClaimTypes.Role
                || c.Type == "role"
                || c.Type == "roles")
            .Select(c => c.Value)
            .ToArray();

        // Keep donor claim assertions explicit so future token-shape refactors do not
        // accidentally break donor-only policy checks in either API or frontend code.
        Assert.Contains("Donor", roleValues);
        Assert.Contains(token.Claims, c => c.Type == ClaimTypes.Role && c.Value == "Donor");
        Assert.Contains(token.Claims, c => c.Type == "role" && c.Value == "Donor");
        Assert.Contains(token.Claims, c => c.Type == "roles" && c.Value == "Donor");
    }

    private sealed record LocalLoginEnvelope(string IdToken);
}
