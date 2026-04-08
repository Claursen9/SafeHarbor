import { Link } from 'react-router-dom'

const missionPoints = [
  'Protect survivor privacy with anonymized reporting and role-based access.',
  'Coordinate services across housing, healthcare, legal aid, and community partners.',
  'Measure impact transparently while safeguarding sensitive records.',
]

export function HomePage() {
  return (
    <section aria-labelledby="home-title">
      <div className="hero-card">
        <p className="eyebrow">501(c)(3) Nonprofit Organization</p>
        <h1 id="home-title">Every Girl Deserves a Safe Harbor</h1>
        <p className="lead">
          SafeHarbor International provides rescue, rehabilitation, and reintegration
          for girls who are survivors of sexual abuse and trafficking — because healing
          is possible.
        </p>
        <div className="cta-row">
          {/* Primary CTA: donate now — the most important action for visitors */}
          <Link to="/donate" className="button button-donate-hero">
            Donate Now →
          </Link>
          <Link to="/impact" className="button button-secondary">
            Stories of Hope
          </Link>
        </div>
      </div>

      <div className="feature-grid" aria-label="Mission highlights">
        {missionPoints.map((point) => (
          <article key={point} className="feature-card">
            <h2>Mission focus</h2>
            <p>{point}</p>
          </article>
        ))}
      </div>
    </section>
  )
}
