-- csp-auth-api inserts and reads the keys of PATCH /me/email through auth_writer, which inherits auth_reader, and deletes them in the
-- retention purge (POST /internal/maintenance/purge, ADR-030). It never updates them. The WHERE clause of the purge reads created_at through
-- the SELECT that auth_writer inherits. Nobody else gets anything, and the other tables keep their grants.
GRANT SELECT ON auth.email_change_idempotency_key TO auth_reader;
GRANT INSERT, DELETE ON auth.email_change_idempotency_key TO auth_writer;
