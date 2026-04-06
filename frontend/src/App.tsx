import './App.css'
import { privacyPolicyContent } from './content/privacyPolicyContent'
import { useCookieConsent } from './hooks/useCookieConsent'

function App() {
  const { hasDecision, state, accept, decline } = useCookieConsent(
    privacyPolicyContent.updatedOnIso
  )

  return (
    <main className="layout">
      <header>
        <h1>SafeHarbor Public Site</h1>
        <p>
          Privacy policy version: <strong>{privacyPolicyContent.updatedOnIso}</strong>
        </p>
      </header>

      {!hasDecision && (
        <section className="consent-banner" aria-live="polite">
          <h2>Cookie preferences</h2>
          <p>
            We use essential cookies for security and optional cookies for analytics.
            Choose your preference to continue.
          </p>
          <div className="actions">
            <button onClick={accept}>Accept optional cookies</button>
            <button className="secondary" onClick={decline}>
              Decline optional cookies
            </button>
          </div>
        </section>
      )}

      {hasDecision && state && (
        <p className="decision">
          Cookie decision: <strong>{state.decision}</strong> on{' '}
          {new Date(state.decidedAtIso).toLocaleString()}.
        </p>
      )}

      <section className="policy">
        <h2>Privacy policy</h2>
        {privacyPolicyContent.sections.map((section) => (
          <article key={section.heading}>
            <h3>{section.heading}</h3>
            {section.paragraphs.map((paragraph) => (
              <p key={paragraph}>{paragraph}</p>
            ))}
          </article>
        ))}
      </section>
    </main>
  )
}

export default App
