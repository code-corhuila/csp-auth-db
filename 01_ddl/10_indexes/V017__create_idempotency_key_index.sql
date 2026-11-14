-- Unique and complete: one key per account, and it is the index of the foreign key, so the cascade
-- from app_user finds the row (Annex A, rule 3). The table is empty here, so it is created in the transaction.
CREATE UNIQUE INDEX uk_idempotency_key_user_id ON auth.idempotency_key (user_id);
