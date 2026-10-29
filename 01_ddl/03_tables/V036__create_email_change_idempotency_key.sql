-- Key with which each email change request was made: mandatory for PATCH /me/email (Norma 5.3.8). Append-only, so it has only
-- created_at. request_hash is the SHA-256 hex digest of the normalised new email and the user id, so another user cannot replay the key and
-- nothing else of the request is stored. email_verification_id links the key to the pending request it created; it is NULL once the purge
-- deleted that request. key is supplied by the client, so it has no default.
CREATE TABLE auth.email_change_idempotency_key (
    key                   text        NOT NULL,
    request_hash          text        NOT NULL,
    email_verification_id uuid,
    created_at            timestamptz NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_email_change_idempotency_key PRIMARY KEY (key),
    CONSTRAINT chk_email_change_idempotency_key_key_length CHECK (char_length(key) BETWEEN 8 AND 128),
    CONSTRAINT chk_email_change_idempotency_key_request_hash_length CHECK (char_length(request_hash) = 64)
);
