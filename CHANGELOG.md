# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2024-04-12

### Added

- Initial release of AshTurso — the Turso/libSQL data layer for Ash Framework
- Full Ash data layer implementation (CRUD, filters, calculations, relationships)
- Three connection modes: local SQLite, remote Turso Cloud, embedded replicas
- Migration generator with automatic migration generation from Ash resources
- Mix tasks: `ash_turso.create`, `ash_turso.drop`, `ash_turso.migrate`, `ash_turso.rollback`, `ash_turso.generate_migrations`, `ash_turso.install`
- `AshTurso.Repo` module with Turso-specific connection configuration
- `AshTurso.DataLayer` with full DSL support (`turso do ... end`)
- Custom indexes, custom statements, references, polymorphic resources
- LIKE/ILIKE functions, manual relationships
- Based on [AshSqlite](https://github.com/ash-project/ash_sqlite), adapted for [ecto_libsql](https://github.com/ocean/ecto_libsql)
