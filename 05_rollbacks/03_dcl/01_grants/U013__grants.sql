-- Reverts V013. Applied before U012 (roles) and U001 (schema), from the highest version down.
REVOKE auth_outbox_reader FROM worker_app;
REVOKE auth_writer FROM auth_app;
REVOKE SELECT ON auth.outbox_event FROM auth_outbox_reader;
REVOKE INSERT, DELETE ON auth.outbox_event FROM auth_writer;
REVOKE INSERT, UPDATE ON auth.app_user, auth.user_role, auth.refresh_token,
                         auth.email_verification, auth.password_reset FROM auth_writer;
REVOKE SELECT ON auth.app_user, auth.role, auth.user_role, auth.refresh_token,
                 auth.email_verification, auth.password_reset FROM auth_reader;
REVOKE auth_reader FROM auth_writer;
REVOKE USAGE ON SCHEMA auth FROM auth_reader, auth_writer, auth_outbox_reader;
