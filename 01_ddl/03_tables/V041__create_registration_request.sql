-- Registration requests (issue csp-docs#282, Norma 5.3.8): every POST /register stores one, whether the email is free or not, so the answer
-- and the stored state do not tell the two cases apart. The account is created only when the owner of the mailbox confirms with the token.
-- The raw token is never stored, only its digest. password_hash, name, phone, address, token_hash and expires_at are filled only when the
-- email was free and the request is within its limit (all together or none: chk_registration_request_payload); a request that created
-- nothing keeps only the key, the hash of the request and the email, which the limit of requests per email counts. idempotency_key is
-- supplied by the client, so it has no default.
CREATE TABLE auth.registration_request (
    id              uuid        NOT NULL DEFAULT gen_random_uuid(),
    idempotency_key text        NOT NULL,
    request_hash    text        NOT NULL,
    email           text        NOT NULL,
    password_hash   text,
    name            text,
    phone           text,
    address         text,
    token_hash      text,
    expires_at      timestamptz,
    used_at         timestamptz,
    created_at      timestamptz NOT NULL DEFAULT NOW(),
    updated_at      timestamptz NOT NULL DEFAULT NOW(),
    deleted_at      timestamptz,
    created_by      uuid,
    updated_by      uuid,
    CONSTRAINT pk_registration_request PRIMARY KEY (id),
    CONSTRAINT uk_registration_request_idempotency_key UNIQUE (idempotency_key),
    CONSTRAINT uk_registration_request_token_hash UNIQUE (token_hash),
    CONSTRAINT chk_registration_request_idempotency_key_length CHECK (char_length(idempotency_key) BETWEEN 8 AND 128),
    CONSTRAINT chk_registration_request_request_hash_length CHECK (char_length(request_hash) = 64),
    CONSTRAINT chk_registration_request_email_length CHECK (char_length(email) BETWEEN 1 AND 255),
    CONSTRAINT chk_registration_request_password_hash_length CHECK (char_length(password_hash) BETWEEN 1 AND 255),
    CONSTRAINT chk_registration_request_name_length CHECK (char_length(name) BETWEEN 1 AND 100),
    CONSTRAINT chk_registration_request_token_hash_length CHECK (char_length(token_hash) BETWEEN 1 AND 255),
    CONSTRAINT chk_registration_request_payload CHECK (
        (password_hash IS NULL AND name IS NULL AND token_hash IS NULL AND expires_at IS NULL)
        OR (password_hash IS NOT NULL AND name IS NOT NULL AND token_hash IS NOT NULL AND expires_at IS NOT NULL)
    )
);
