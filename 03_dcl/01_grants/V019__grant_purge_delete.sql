-- Retention purge (POST /internal/maintenance/purge, ADR-030): csp-auth-api deletes refresh tokens expired or
-- revoked more than 30 days ago and idempotency keys older than 7 days, as auth_writer. Only DELETE is added: the
-- WHERE clause reads expires_at, revoked_at and created_at through the SELECT that auth_writer already inherits
-- from auth_reader (V013, V018). Nobody else gets anything, and the other tables stay without DELETE.
GRANT DELETE ON auth.refresh_token, auth.idempotency_key TO auth_writer;
