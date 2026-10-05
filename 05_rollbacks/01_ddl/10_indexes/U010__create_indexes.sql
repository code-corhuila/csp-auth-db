-- Reverts V010.
DROP INDEX IF EXISTS auth.idx_outbox_event_created_at;
DROP INDEX IF EXISTS auth.idx_password_reset_expires_at;
DROP INDEX IF EXISTS auth.idx_email_verification_expires_at;
DROP INDEX IF EXISTS auth.idx_refresh_token_expires_at;
DROP INDEX IF EXISTS auth.idx_password_reset_user_id;
DROP INDEX IF EXISTS auth.idx_email_verification_user_id;
DROP INDEX IF EXISTS auth.idx_refresh_token_user_id;
DROP INDEX IF EXISTS auth.idx_user_role_role_id;
DROP INDEX IF EXISTS auth.idx_user_role_user_id;
DROP INDEX IF EXISTS auth.idx_app_user_deleted_at;
DROP INDEX IF EXISTS auth.uk_app_user_email;
