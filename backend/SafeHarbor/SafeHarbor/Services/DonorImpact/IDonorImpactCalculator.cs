namespace SafeHarbor.Services.DonorImpact;

/// <summary>
/// Calculates a donor's real-world impact from their lifetime giving total.
///
/// WHY THIS INTERFACE EXISTS (ML integration seam):
///   The current implementation uses a simple cost-per-outcome formula.
///   When the ML pipeline is ready, create a new class that implements this interface
///   (e.g. MlImpactCalculator) and update the DI registration in Program.cs:
///
///     builder.Services.AddSingleton&lt;IDonorImpactCalculator, MlImpactCalculator&gt;();
///
///   The controller and frontend are unaffected by this swap.
/// </summary>
public interface IDonorImpactCalculator
{
    /// <summary>
    /// Computes an impact score from a donor's lifetime donated amount.
    /// </summary>
    /// <param name="lifetimeDonated">Total USD the donor has given across all completed contributions.</param>
    /// <returns>An <see cref="ImpactScore"/> describing the derived impact.</returns>
    ImpactScore Calculate(decimal lifetimeDonated);
}

/// <summary>
/// The result of an impact calculation. Returned as part of the donor dashboard response
/// so the frontend can display both the number and the methodology that produced it.
/// </summary>
/// <param name="GirlsHelped">
///   Estimated number of girls supported based on the donor's total giving.
/// </param>
/// <param name="CostPerOutcome">
///   USD cost per girl helped used in this calculation (for transparency / audit trail).
/// </param>
/// <param name="ImpactLabel">
///   Human-readable description shown beneath the number on the donor dashboard,
///   e.g. "girls supported toward safe housing".
/// </param>
/// <param name="ModelVersion">
///   Identifier for the calculation method used. Shown as a small badge on the
///   dashboard so donors and staff can tell which model produced the result.
///   Examples: "rule-based-v1", "ml-v2".
/// </param>
public sealed record ImpactScore(
    int GirlsHelped,
    decimal CostPerOutcome,
    string ImpactLabel,
    string ModelVersion);
