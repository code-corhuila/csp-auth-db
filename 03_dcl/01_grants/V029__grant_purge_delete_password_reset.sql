-- Retention purge of password reset tokens (HU-AUTH-006): csp-auth-api deletes the rows whose expires_at is more than 7 days old,
-- used or not, as auth_writer. Only DELETE is added: the WHERE clause reads expires_at through the SELECT that auth_writer already
-- inherits from auth_reader (V013). Nobody else gets anything, and the other tables keep their grants.
GRANT DELETE ON auth.password_reset TO auth_writer;
