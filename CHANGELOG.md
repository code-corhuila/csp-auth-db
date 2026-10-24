# Changelog

All notable changes of `csp-auth-db` are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Each change is recorded in the pull request that introduces it.
Applied migrations are frozen: a change of the schema is always a new version.

## [Unreleased]

## [3.0.0] - 2026-10-15

Everything below is in `develop`; it is promoted to `qa` and `main` only when it is ordered.

### Added

- Migrations V028 to V030 and their rollbacks U028 to U030, for the password reset of HU-AUTH-006: the partial unique index
  `uk_password_reset_user_id_pending` (one active request per user: pending means `used_at` and `deleted_at` null, and a new request
  soft-deletes the previous one, as in V025), `DELETE` for `auth_writer` on `auth.password_reset` for the retention purge (no other
  role or table changes) and the complete index `idx_password_reset_expires_at_complete`, because the V010 index is partial on
  unused rows and cannot serve a used one. The two indexes are built `CONCURRENTLY`, each in its own migration. CI checks the
  grant, that auth_writer deletes exactly five tables, the second pending request and the indexes.
- Migrations V026 and V027 and their rollbacks U026 and U027, for the retention purge of `auth.email_verification` (ADR-030,
  ADR-034): `DELETE` for `auth_writer` on the table (the `WHERE` reads through the `SELECT` it already inherits; no other role or
  table changes) and the complete index `idx_email_verification_expires_at_complete`, built `CONCURRENTLY` in its own migration
  because the V010 index is partial on unverified rows and cannot serve a verified one. CI checks the grant, that auth_writer
  deletes exactly four tables, and that the index exists, is valid and complete.
- Migrations V024 and V025 and their rollbacks U024 and U025: `auth.email_verification` gets `new_email` (the address being verified)
  and `attempt_count` (wrong codes, 0 to 5) with named checks, and the partial unique index `uk_email_verification_user_id_pending`
  (one active request per user, built `CONCURRENTLY` in its own migration), for the email change of HU-AUTH-004 (ADR-034). CI
  checks the defaults, the checks, the second pending request and the index.
  ([#35](https://github.com/code-corhuila/csp-auth-db/issues/35))
- Migration V023 and its rollback U023: `idx_app_user_email_pattern`, a partial `text_pattern_ops` index on `auth.app_user (email)`
  built `CONCURRENTLY` in its own migration, so `GET /users` can answer `email LIKE 'prefix%'` without scanning the table. CI checks
  that it exists, is valid and is partial.
  ([#31](https://github.com/code-corhuila/csp-auth-db/issues/31))
- Migrations V020 to V022 and their rollbacks U020 to U022: indexes for the retention purge (ADR-030), each built `CONCURRENTLY` in
  its own migration: `idx_refresh_token_revoked_at` (partial, revoked rows), `idx_refresh_token_expires_at_complete` (complete;
  the V010 index is partial and cannot serve a revoked row that also expired) and `idx_idempotency_key_created_at`. CI checks
  that they exist, are valid and have the expected shape.
  ([#18](https://github.com/code-corhuila/csp-auth-db/issues/18))
- Migration V019 and its rollback U019: `DELETE` for `auth_writer` on `auth.refresh_token` and `auth.idempotency_key`, for the
  retention purge (ADR-030). The `WHERE` reads through the `SELECT` it already inherits; no other role or table changes. CI
  checks that nothing else is deletable.
  ([#26](https://github.com/code-corhuila/csp-auth-db/issues/26))
- Migrations V015 to V018 and their rollbacks U015 to U018: table `auth.idempotency_key` (the key with which each account was
  registered, with the hash of the request), its foreign key to `app_user` with `ON DELETE CASCADE`, its unique full index and
  its grants (`auth_reader` reads, `auth_writer` inserts, nobody updates or deletes). CI checks for the constraints, the
  cascade, the keys of 7 and 129 characters and the privileges.
  ([#24](https://github.com/code-corhuila/csp-auth-db/pull/24))
- Checks of the seed, the roles, the grants and the constraints of the schema in the CI rebuild job
  ([#15](https://github.com/code-corhuila/csp-auth-db/pull/15)).
- This changelog ([#25](https://github.com/code-corhuila/csp-auth-db/pull/25)).

## Before the changelog

- Base: governance files, schema `auth` with its tables, constraints, seeds and roles (V001 to V013), the Flyway migration
  executor, the CI rebuild check and the README.
  ([#1](https://github.com/code-corhuila/csp-auth-db/pull/1) to [#5](https://github.com/code-corhuila/csp-auth-db/pull/5))
- Phone and address columns of `app_user` (V014, [#9](https://github.com/code-corhuila/csp-auth-db/pull/9)).
- Promotions to `qa`: [#6](https://github.com/code-corhuila/csp-auth-db/pull/6) to
  [#8](https://github.com/code-corhuila/csp-auth-db/pull/8), [#10](https://github.com/code-corhuila/csp-auth-db/pull/10),
  [#11](https://github.com/code-corhuila/csp-auth-db/pull/11), [#14](https://github.com/code-corhuila/csp-auth-db/pull/14)
  and [#16](https://github.com/code-corhuila/csp-auth-db/pull/16).
- Promotions to `main`: release `0.1.0` ([#12](https://github.com/code-corhuila/csp-auth-db/pull/12)) and release `0.1.1`
  ([#13](https://github.com/code-corhuila/csp-auth-db/pull/13)).
