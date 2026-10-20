-- Retention purge of email verification codes (ADR-030, ADR-034): csp-auth-api deletes the rows whose expires_at is more than
-- 7 days old, verified or not, as auth_writer. Only DELETE is added: the WHERE clause reads expires_at through the SELECT that
-- auth_writer already inherits from auth_reader (V013). Nobody else gets anything, and the other tables keep their grants.
GRANT DELETE ON auth.email_verification TO auth_writer;
