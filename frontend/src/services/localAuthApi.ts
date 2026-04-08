import type { AppRole } from '../auth/authSession'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? ''
const LOCAL_LOGIN_ENDPOINT = '/api/auth/local-login'
const LOCAL_REGISTER_ENDPOINT = '/api/auth/local-register'

type LocalLoginResponse = {
  idToken: string
}

type LocalRegisterRequest = {
  email: string
  role: AppRole
  password: string
}

/**
 * Development-only helper that exchanges an email+role selection for a signed JWT
 * from the backend. This lets local testing exercise real bearer-token plumbing.
 */
export async function requestLocalDevelopmentToken(email: string, role: AppRole, password: string): Promise<string> {
  const response = await fetch(`${API_BASE}${LOCAL_LOGIN_ENDPOINT}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify({ email, role, password }),
  })

  if (!response.ok) {
    const errorBody = (await response.json().catch(() => ({}))) as { error?: string }
    throw new Error(errorBody.error ?? `Local login failed with status ${response.status}`)
  }

  const body = (await response.json()) as LocalLoginResponse
  return body.idToken
}

/**
 * Creates a local-development account that can later request JWTs via /local-login.
 * The backend stores accounts in-memory only, so this is intentionally local and ephemeral.
 */
export async function registerLocalDevelopmentAccount(request: LocalRegisterRequest): Promise<void> {
  const response = await fetch(`${API_BASE}${LOCAL_REGISTER_ENDPOINT}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body: JSON.stringify(request),
  })

  if (!response.ok) {
    const errorBody = (await response.json().catch(() => ({}))) as { error?: string }
    throw new Error(errorBody.error ?? `Local account creation failed with status ${response.status}`)
  }
}
