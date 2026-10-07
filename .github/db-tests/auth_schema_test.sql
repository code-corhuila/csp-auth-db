-- Behaviour tests of the auth schema. Run by db-ci.yml after the migrations, as the admin user.
-- Every check raises an exception when it fails; data checks run inside a transaction that is rolled back.
\set ON_ERROR_STOP on

CREATE FUNCTION pg_temp.expect(ok boolean, label text) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  IF ok IS NOT TRUE THEN
    RAISE EXCEPTION 'FAILED: %', label;
  END IF;
  RAISE NOTICE 'ok: %', label;
END
$$;

CREATE FUNCTION pg_temp.rejects(statement text, label text) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  BEGIN
    EXECUTE statement;
  EXCEPTION WHEN integrity_constraint_violation THEN
    RAISE NOTICE 'ok: %', label;
    RETURN;
  END;
  RAISE EXCEPTION 'FAILED: % (the statement was accepted)', label;
END
$$;

-- Seed (V011)
SELECT pg_temp.expect((SELECT count(*) FROM auth.role WHERE name IN ('CLIENT', 'ADMIN')) = 2, 'seed: roles CLIENT and ADMIN exist');

-- Roles (V012): no role of the schema can log in
SELECT pg_temp.expect(
  (SELECT count(*) FROM pg_roles WHERE rolname IN ('auth_reader', 'auth_writer', 'auth_outbox_reader') AND NOT rolcanlogin) = 3,
  'roles: the three schema roles are NOLOGIN');

-- Grants (V013)
SELECT pg_temp.expect(has_table_privilege('auth_reader', 'auth.app_user', 'SELECT'), 'grants: auth_reader reads app_user');
SELECT pg_temp.expect(NOT has_table_privilege('auth_reader', 'auth.app_user', 'INSERT, UPDATE, DELETE'), 'grants: auth_reader cannot write app_user');
SELECT pg_temp.expect(has_table_privilege('auth_writer', 'auth.app_user', 'INSERT') AND has_table_privilege('auth_writer', 'auth.app_user', 'UPDATE'), 'grants: auth_writer inserts and updates app_user');
SELECT pg_temp.expect(NOT has_table_privilege('auth_writer', 'auth.app_user', 'DELETE'), 'grants: auth_writer cannot delete app_user');
SELECT pg_temp.expect(has_table_privilege('auth_writer', 'auth.outbox_event', 'INSERT') AND has_table_privilege('auth_writer', 'auth.outbox_event', 'DELETE'), 'grants: auth_writer inserts and purges the outbox');
SELECT pg_temp.expect(has_column_privilege('auth_writer', 'auth.outbox_event', 'id', 'SELECT') AND has_column_privilege('auth_writer', 'auth.outbox_event', 'created_at', 'SELECT'), 'grants: auth_writer reads id and created_at of the outbox');
SELECT pg_temp.expect(NOT has_column_privilege('auth_writer', 'auth.outbox_event', 'payload', 'SELECT'), 'grants: auth_writer cannot read the outbox payload');
SELECT pg_temp.expect(has_table_privilege('auth_outbox_reader', 'auth.outbox_event', 'SELECT'), 'grants: auth_outbox_reader reads the outbox');
SELECT pg_temp.expect(NOT has_table_privilege('auth_outbox_reader', 'auth.outbox_event', 'INSERT, UPDATE, DELETE'), 'grants: auth_outbox_reader cannot write the outbox');
SELECT pg_temp.expect(NOT has_table_privilege('auth_outbox_reader', 'auth.app_user', 'SELECT'), 'grants: auth_outbox_reader sees only the outbox');
SELECT pg_temp.expect(pg_has_role('worker_app', 'auth_outbox_reader', 'MEMBER') AND NOT pg_has_role('worker_app', 'auth_writer', 'MEMBER'), 'grants: worker_app is member of the outbox reader only');
SELECT pg_temp.expect(pg_has_role('auth_app', 'auth_writer', 'MEMBER'), 'grants: auth_app is member of auth_writer');

-- Constraints and indexes
BEGIN;

INSERT INTO auth.app_user (id, email, name, password_hash, phone, address)
VALUES ('00000000-0000-0000-0000-000000000001', 'ana@example.com', 'Ana', 'hash', '+573001234567', 'Calle 1 # 2-3');

SELECT pg_temp.expect((SELECT status FROM auth.app_user WHERE id = '00000000-0000-0000-0000-000000000001') = 'ACTIVE', 'app_user: a new user is ACTIVE');
SELECT pg_temp.expect((SELECT NOT email_verified FROM auth.app_user WHERE id = '00000000-0000-0000-0000-000000000001'), 'app_user: email starts unverified');

SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash, status) VALUES ('b@example.com', 'B', 'h', 'BANNED')$$, 'app_user: unknown status is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash) VALUES ('', 'B', 'h')$$, 'app_user: empty email is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash) VALUES ('c@example.com', repeat('n', 101), 'h')$$, 'app_user: name over 100 characters is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash, phone) VALUES ('d@example.com', 'D', 'h', 'abc')$$, 'app_user: malformed phone is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash, phone) VALUES ('e@example.com', 'E', 'h', '123456')$$, 'app_user: phone with fewer than 7 digits is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash, address) VALUES ('f@example.com', 'F', 'h', '')$$, 'app_user: empty address is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.app_user (email, name, password_hash) VALUES ('ana@example.com', 'Other', 'h')$$, 'app_user: duplicate active email is rejected');

UPDATE auth.app_user SET deleted_at = NOW() WHERE id = '00000000-0000-0000-0000-000000000001';
INSERT INTO auth.app_user (email, name, password_hash) VALUES ('ana@example.com', 'Ana again', 'h');
SELECT pg_temp.expect((SELECT count(*) FROM auth.app_user WHERE email = 'ana@example.com') = 2, 'app_user: an email can be reused after the soft delete');

INSERT INTO auth.app_user (id, email, name, password_hash) VALUES ('00000000-0000-0000-0000-000000000002', 'luis@example.com', 'Luis', 'h');
INSERT INTO auth.user_role (user_id, role_id) SELECT '00000000-0000-0000-0000-000000000002', id FROM auth.role WHERE name = 'CLIENT';
SELECT pg_temp.rejects($$INSERT INTO auth.user_role (user_id, role_id) SELECT '00000000-0000-0000-0000-000000000002', id FROM auth.role WHERE name = 'CLIENT'$$, 'user_role: the same role twice is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.user_role (user_id, role_id) SELECT '00000000-0000-0000-0000-0000000000ff', id FROM auth.role WHERE name = 'ADMIN'$$, 'user_role: an unknown user is rejected');
SELECT pg_temp.rejects($$DELETE FROM auth.role WHERE name = 'CLIENT'$$, 'role: a role in use cannot be deleted');

INSERT INTO auth.refresh_token (user_id, token_hash, expires_at) VALUES ('00000000-0000-0000-0000-000000000002', 'token-1', NOW() + interval '1 day');
SELECT pg_temp.rejects($$INSERT INTO auth.refresh_token (user_id, token_hash, expires_at) VALUES ('00000000-0000-0000-0000-000000000002', 'token-1', NOW())$$, 'refresh_token: duplicate token hash is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.email_verification (user_id, verification_code, expires_at) VALUES ('00000000-0000-0000-0000-000000000002', '12345', NOW())$$, 'email_verification: a code of 5 digits is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.password_reset (user_id, token_hash, expires_at) VALUES ('00000000-0000-0000-0000-000000000002', '', NOW())$$, 'password_reset: empty token hash is rejected');
SELECT pg_temp.rejects($$INSERT INTO auth.outbox_event (id, aggregate_type, aggregate_id, event_type, payload) VALUES (gen_random_uuid(), '', gen_random_uuid(), 'UserRegistered', '{}')$$, 'outbox_event: empty aggregate type is rejected');

DELETE FROM auth.app_user WHERE id = '00000000-0000-0000-0000-000000000002';
SELECT pg_temp.expect((SELECT count(*) FROM auth.user_role WHERE user_id = '00000000-0000-0000-0000-000000000002') = 0, 'app_user: deleting a user removes its roles');
SELECT pg_temp.expect((SELECT count(*) FROM auth.refresh_token WHERE user_id = '00000000-0000-0000-0000-000000000002') = 0, 'app_user: deleting a user removes its refresh tokens');

ROLLBACK;
