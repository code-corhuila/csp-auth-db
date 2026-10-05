-- Events written by csp-auth-api in the same transaction as the identity change (ADR-019).
-- No processed_at and no audit columns: csp-worker only reads this table and keeps the
-- publication state in its own schema. id is the eventId of the published event, so it has no default.
CREATE TABLE auth.outbox_event (
    id             uuid        NOT NULL,
    aggregate_type text        NOT NULL,
    aggregate_id   uuid        NOT NULL,
    event_type     text        NOT NULL,
    payload        jsonb       NOT NULL,
    created_at     timestamptz NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_outbox_event PRIMARY KEY (id),
    CONSTRAINT chk_outbox_event_aggregate_type_length CHECK (char_length(aggregate_type) BETWEEN 1 AND 100),
    CONSTRAINT chk_outbox_event_event_type_length CHECK (char_length(event_type) BETWEEN 1 AND 100)
);
