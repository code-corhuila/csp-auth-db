-- RBAC roles. CLIENT and ADMIN are seeded by a later migration.
CREATE TABLE auth.role (
    id          uuid        NOT NULL DEFAULT gen_random_uuid(),
    name        text        NOT NULL,
    description text,
    created_at  timestamptz NOT NULL DEFAULT NOW(),
    updated_at  timestamptz NOT NULL DEFAULT NOW(),
    deleted_at  timestamptz,
    created_by  uuid,
    updated_by  uuid,
    CONSTRAINT pk_role PRIMARY KEY (id),
    CONSTRAINT uk_role_name UNIQUE (name),
    CONSTRAINT chk_role_name_length CHECK (char_length(name) BETWEEN 1 AND 50)
);
