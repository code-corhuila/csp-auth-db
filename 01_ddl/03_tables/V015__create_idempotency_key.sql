-- Key with which each account was registered: mandatory for POST /register (Norma 5.3.8). Append-only,
-- so it has only created_at. request_hash is the SHA-256 hex digest of the request without the password,
-- so nothing derived from the password is stored. key is supplied by the client, so it has no default.
CREATE TABLE auth.idempotency_key (
    key          text        NOT NULL,
    user_id      uuid        NOT NULL,
    request_hash text        NOT NULL,
    created_at   timestamptz NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_idempotency_key PRIMARY KEY (key),
    CONSTRAINT chk_idempotency_key_key_length CHECK (char_length(key) BETWEEN 8 AND 128),
    CONSTRAINT chk_idempotency_key_request_hash_length CHECK (char_length(request_hash) BETWEEN 1 AND 255)
);
