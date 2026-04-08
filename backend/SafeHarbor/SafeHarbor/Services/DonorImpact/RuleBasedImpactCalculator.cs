using Microsoft.Extensions.Configuration;

namespace SafeHarbor.Services.DonorImpact;

/// <summary>
/// Default implementation of <see cref="IDonorImpactCalculator"/> that uses a
/// cost-per-outcome formula to estimate how many girls a donor has helped.
///
/// FORMULA:
///   girlsHelped = floor(lifetimeDonated / costPerOutcome)
///
/// The cost-per-outcome constant defaults to $47 but can be overridden without a
/// redeploy by setting "DonorImpact:CostPerOutcome" in appsettings.json or
/// environment variables.
///
/// TO SWAP IN AN ML MODEL:
///   1. Create a new class that implements IDonorImpactCalculator.
///   2. In Program.cs, change:
///        builder.Services.AddSingleton&lt;IDonorImpactCalculator, RuleBasedImpactCalculator&gt;();
///      to:
///        builder.Services.AddSingleton&lt;IDonorImpactCalculator, MlImpactCalculator&gt;();
///   3. No other changes needed — the controller and frontend are unaffected.
/// </summary>
public sealed class RuleBasedImpactCalculator : IDonorImpactCalculator
{
    // Default cost per girl helped, in USD.
    // Source: organizational cost-per-outcome estimate (update as data improves).
    private const decimal DefaultCostPerOutcome = 47m;

    private readonly decimal _costPerOutcome;

    /// <summary>
    /// Reads the cost-per-outcome from configuration so it can be updated without a redeploy.
    /// Falls back to <c>$47</c> if the key is missing or invalid.
    /// </summary>
    public RuleBasedImpactCalculator(IConfiguration configuration)
    {
        // Try to read an override from appsettings.json or environment variables.
        // Example config entry: "DonorImpact": { "CostPerOutcome": 52.50 }
        var raw = configuration["DonorImpact:CostPerOutcome"];
        _costPerOutcome = decimal.TryParse(raw, out var parsed) && parsed > 0
            ? parsed
            : DefaultCostPerOutcome;
    }

    /// <inheritdoc />
    /// <remarks>
    /// Uses integer division (floor) so the result never overstates impact.
    /// A donor who has given $46 sees 0 girls helped, encouraging them to reach the $47 threshold.
    /// </remarks>
    public ImpactScore Calculate(decimal lifetimeDonated)
    {
        // Floor division: we never round up impact to avoid overstating outcomes.
        var girlsHelped = lifetimeDonated > 0
            ? (int)(lifetimeDonated / _costPerOutcome)
            : 0;

        return new ImpactScore(
            GirlsHelped: girlsHelped,
            CostPerOutcome: _costPerOutcome,
            ImpactLabel: "girls supported toward safe housing",
            ModelVersion: "rule-based-v1");
    }
}
