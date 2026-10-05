-- Reverts V009.
ALTER TABLE auth.password_reset DROP CONSTRAINT IF EXISTS fk_password_reset_app_user;
ALTER TABLE auth.email_verification DROP CONSTRAINT IF EXISTS fk_email_verification_app_user;
ALTER TABLE auth.refresh_token DROP CONSTRAINT IF EXISTS fk_refresh_token_app_user;
ALTER TABLE auth.user_role DROP CONSTRAINT IF EXISTS fk_user_role_role;
ALTER TABLE auth.user_role DROP CONSTRAINT IF EXISTS fk_user_role_app_user;
