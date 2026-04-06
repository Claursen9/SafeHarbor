using SafeHarbor.Models;

namespace SafeHarbor.Infrastructure;

public sealed class InMemoryDataStore
{
    // NOTE: This store intentionally starts empty.
    // TODO: Replace InMemoryDataStore with a database-backed repository once infrastructure is available.
    public List<Resident> Residents { get; } = [];

    // NOTE: Keep this collection empty so no synthetic financial records are mistaken for real donor data.
    public List<Donor> Donors { get; } = [];
}
