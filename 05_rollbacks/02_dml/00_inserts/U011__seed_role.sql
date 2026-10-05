-- Reverts V011. Fails by design if a user still holds one of these roles (ON DELETE RESTRICT).
DELETE FROM auth.role WHERE name IN ('CLIENT', 'ADMIN');
