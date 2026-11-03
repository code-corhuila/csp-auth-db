-- The purge of email_verification rows must not fail because a key still points at one: the link is cleared and the key stays until its own
-- retention ends. The foreign key column is indexed by V038.
ALTER TABLE auth.email_change_idempotency_key
    ADD CONSTRAINT fk_email_change_idempotency_key_email_verification
    FOREIGN KEY (email_verification_id) REFERENCES auth.email_verification (id) ON DELETE SET NULL;
