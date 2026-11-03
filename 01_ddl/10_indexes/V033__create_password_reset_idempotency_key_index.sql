-- Complete (not partial): it is the index of the foreign key, so ON DELETE SET NULL from password_reset finds the rows (Annex A, rule 3).
-- The table is empty here, so it is created in the transaction.
CREATE INDEX idx_password_reset_idempotency_key_password_reset_id ON auth.password_reset_idempotency_key (password_reset_id);
