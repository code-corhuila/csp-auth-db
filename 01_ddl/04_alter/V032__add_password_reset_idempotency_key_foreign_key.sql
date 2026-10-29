-- The purge of password_reset rows must not fail because a key still points at one: the link is cleared and the key stays until its own
-- retention ends. The foreign key column is indexed by V033.
ALTER TABLE auth.password_reset_idempotency_key
    ADD CONSTRAINT fk_password_reset_idempotency_key_password_reset
    FOREIGN KEY (password_reset_id) REFERENCES auth.password_reset (id) ON DELETE SET NULL;
