-- Roles of the auth domain (ADR-019). They carry permissions only: NOLOGIN and no password.
-- The login user (auth_app) is created by csp-infra-postgres from secrets.
-- Roles belong to the whole instance, so every name starts with the domain (Annex J).
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auth_reader') THEN
    CREATE ROLE auth_reader NOLOGIN;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auth_writer') THEN
    CREATE ROLE auth_writer NOLOGIN;
  END IF;
  -- Read-only access of csp-worker to auth.outbox_event (ADR-019). Narrower than auth_reader on purpose.
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auth_outbox_reader') THEN
    CREATE ROLE auth_outbox_reader NOLOGIN;
  END IF;
END
$$;
