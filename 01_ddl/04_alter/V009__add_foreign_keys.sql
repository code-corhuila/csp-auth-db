-- Foreign keys, each one declaring what happens on delete (Annex A, rule 2).
-- Every foreign key column is indexed by V010.
ALTER TABLE auth.user_role
    ADD CONSTRAINT fk_user_role_app_user
    FOREIGN KEY (user_id) REFERENCES auth.app_user (id) ON DELETE CASCADE;

ALTER TABLE auth.user_role
    ADD CONSTRAINT fk_user_role_role
    FOREIGN KEY (role_id) REFERENCES auth.role (id) ON DELETE RESTRICT;

ALTER TABLE auth.refresh_token
    ADD CONSTRAINT fk_refresh_token_app_user
    FOREIGN KEY (user_id) REFERENCES auth.app_user (id) ON DELETE CASCADE;

ALTER TABLE auth.email_verification
    ADD CONSTRAINT fk_email_verification_app_user
    FOREIGN KEY (user_id) REFERENCES auth.app_user (id) ON DELETE CASCADE;

ALTER TABLE auth.password_reset
    ADD CONSTRAINT fk_password_reset_app_user
    FOREIGN KEY (user_id) REFERENCES auth.app_user (id) ON DELETE CASCADE;
