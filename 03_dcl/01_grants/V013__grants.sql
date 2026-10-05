-- csp-auth-api writes only through auth_writer, which also reads (it inherits auth_reader).
GRANT USAGE ON SCHEMA auth TO auth_reader, auth_writer, auth_outbox_reader;
GRANT auth_reader TO auth_writer;

GRANT SELECT ON auth.app_user, auth.role, auth.user_role, auth.refresh_token,
                auth.email_verification, auth.password_reset TO auth_reader;
GRANT INSERT, UPDATE ON auth.app_user, auth.user_role, auth.refresh_token,
                        auth.email_verification, auth.password_reset TO auth_writer;
-- The API appends events and purges the ones older than 30 days (POST /internal/maintenance/purge,
-- ADR-019); it never reads their content back. A DELETE with a WHERE needs SELECT on the columns it
-- reads, so the purge gets id and created_at only, not payload. The worker may only read them.
GRANT INSERT, DELETE ON auth.outbox_event TO auth_writer;
GRANT SELECT (id, created_at) ON auth.outbox_event TO auth_writer;
GRANT SELECT ON auth.outbox_event TO auth_outbox_reader;

-- The login users already exist: csp-infra-postgres creates them before the migrations run (Annex J.5.5).
GRANT auth_writer TO auth_app;
GRANT auth_outbox_reader TO worker_app;
