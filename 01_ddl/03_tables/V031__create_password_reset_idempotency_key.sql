-- Key with which each password reset request was made: mandatory for POST /forgot-password (Norma 5.3.8). Append-only, so it has only
-- created_at. request_hash is the SHA-256 hex digest of the normalised email, so nothing else of the request is stored. password_reset_id
-- links the key to the token it created; it is NULL when the request created none (unknown, inactive or limited account), so a replay
-- is indistinguishable. key is supplied by the client, so it has no default.
CREATE TABLE auth.password_reset_idempotency_key (
    key               text        NOT NULL,
    request_hash      text        NOT NULL,
    password_reset_id uuid,
    created_at        timestamptz NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_password_reset_idempotency_key PRIMARY KEY (key),
    CONSTRAINT chk_password_reset_idempotency_key_key_length CHECK (char_length(key) BETWEEN 8 AND 128),
    CONSTRAINT chk_password_reset_idempotency_key_request_hash_length CHECK (char_length(request_hash) = 64)
);
