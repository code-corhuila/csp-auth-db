-- Reverts V012. U013 has already removed every privilege and membership of these roles.
DROP ROLE IF EXISTS auth_outbox_reader;
DROP ROLE IF EXISTS auth_writer;
DROP ROLE IF EXISTS auth_reader;
