-- csp-auth-api writes registration requests as auth_writer and purges the ones older than 7 days (ADR-030); the WHERE clause reads
-- created_at through the SELECT that auth_writer inherits from auth_reader. Nobody else gets anything.
GRANT SELECT ON auth.registration_request TO auth_reader;
GRANT INSERT, UPDATE, DELETE ON auth.registration_request TO auth_writer;
