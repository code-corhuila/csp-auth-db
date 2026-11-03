-- The key dies with its account. The foreign key column is indexed by V017.
ALTER TABLE auth.idempotency_key
    ADD CONSTRAINT fk_idempotency_key_app_user
    FOREIGN KEY (user_id) REFERENCES auth.app_user (id) ON DELETE CASCADE;
