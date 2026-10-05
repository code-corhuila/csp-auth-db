-- Idempotent: an upsert against the unique name, never a bare INSERT (Annex A, rule 11).
INSERT INTO auth.role (name, description) VALUES
    ('CLIENT', 'Customer of the cinema: books seats and orders concessions'),
    ('ADMIN',  'Administrator of the platform')
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description;
