-- Roles assigned to users. created_by is who assigned the role. Foreign keys go in 04_alter.
CREATE TABLE auth.user_role (
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    user_id    uuid        NOT NULL,
    role_id    uuid        NOT NULL,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    updated_at timestamptz NOT NULL DEFAULT NOW(),
    deleted_at timestamptz,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT pk_user_role PRIMARY KEY (id),
    CONSTRAINT uk_user_role_user_id_role_id UNIQUE (user_id, role_id)
);
