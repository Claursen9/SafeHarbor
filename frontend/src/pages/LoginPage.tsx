import { useState, type FormEvent } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { roles, type AppRole } from '../auth/authSession'

export function LoginPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const { login } = useAuth()
  const [email, setEmail] = useState('')
  // Default to Admin since that's the most common staff use-case in development.
  // Donors should select the "Donor" role to be redirected to /donor/dashboard.
  const [role, setRole] = useState<AppRole>('Admin')
  const [error, setError] = useState<string | null>(null)

  const handleCredentialsSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    if (!email.trim()) {
      setError('Please enter your work email.')
      return
    }

    login(email.trim(), role)

    // Redirect based on role: donors go to their personal dashboard,
    // staff go to the admin dashboard (or wherever they were trying to reach).
    const destination = (location.state as { from?: { pathname?: string } } | null)?.from?.pathname
    const defaultDestination = role === 'Donor' ? '/donor/dashboard' : '/app/dashboard'
    navigate(destination ?? defaultDestination, { replace: true })
  }

  return (
    <section aria-labelledby="login-title" className="auth-layout">
      <div className="auth-card">
        <h1 id="login-title">Sign in</h1>
        {/* Staff: select Admin or SocialWorker. Donors: select Donor to reach your giving dashboard. */}
        <p className="caption">Select your role to access your dashboard.</p>

        {error && (
          <p className="form-error" role="alert">
            {error}
          </p>
        )}

        <form onSubmit={handleCredentialsSubmit} className="auth-form">
          <label htmlFor="email">Work email</label>
          <input
            id="email"
            name="email"
            autoComplete="email"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />

          <label htmlFor="role">Role</label>
          <select id="role" value={role} onChange={(event) => setRole(event.target.value as AppRole)}>
            {roles.map((roleOption) => (
              <option key={roleOption} value={roleOption}>
                {roleOption}
              </option>
            ))}
          </select>

          <button type="submit" className="button button-primary">
            Sign in
          </button>
        </form>
      </div>
    </section>
  )
}
