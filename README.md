# AshTurso

[![Hex.pm](https://img.shields.io/hexpm/v/ash_turso.svg)](https://hex.pm/packages/ash_turso)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The [Turso](https://turso.tech)/libSQL data layer for [Ash Framework](https://ash-hq.org).

AshTurso allows you to use Turso (distributed SQLite) as your database with Ash Framework, powered by [ecto_libsql](https://github.com/ocean/ecto_libsql).

## Features

- **Full Ash data layer** — CRUD, filters, aggregates, calculations, relationships
- **Three connection modes** — local SQLite (dev), Turso Cloud (prod), embedded replicas (edge)
- **Migration generator** — automatic migration generation from your Ash resources
- **Drop-in familiar** — if you've used `AshSqlite`, you already know `AshTurso`
- **SQLite compatible** — same SQL dialect, same type system, same expressions

## Installation

Add `ash_turso` to your `mix.exs`:

```elixir
def deps do
  [
    {:ash_turso, "~> 0.1.0"}
  ]
end
```

## Quick Start

### 1. Define your Repo

```elixir
defmodule MyApp.Repo do
  use AshTurso.Repo, otp_app: :my_app
end
```

### 2. Configure connection

```elixir
# config/dev.exs — Local SQLite (no Turso account needed)
config :my_app, MyApp.Repo,
  database: "my_app_dev.db"

# config/prod.exs — Turso Cloud
config :my_app, MyApp.Repo,
  uri: "libsql://your-db.turso.io",
  auth_token: System.get_env("TURSO_AUTH_TOKEN")

# config/prod.exs — Embedded Replica (best of both worlds)
config :my_app, MyApp.Repo,
  database: "my_app.db",
  uri: "libsql://your-db.turso.io",
  auth_token: System.get_env("TURSO_AUTH_TOKEN"),
  sync: true
```

### 3. Add the data layer to your resources

```elixir
defmodule MyApp.Blog.Post do
  use Ash.Resource,
    domain: MyApp.Blog,
    data_layer: AshTurso.DataLayer

  turso do
    repo MyApp.Repo
    table "posts"
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
    attribute :body, :string
    timestamps()
  end

  actions do
    defaults [:read, :destroy, create: [:title, :body], update: [:title, :body]]
  end
end
```

### 4. Generate and run migrations

```bash
mix ash_turso.generate_migrations
mix ash_turso.create
mix ash_turso.migrate
```

## Connection Modes Explained

### Local Mode (Development)

Uses a plain SQLite file on disk. No Turso account needed. Perfect for development and testing.

```elixir
config :my_app, MyApp.Repo,
  database: "my_app_dev.db"
```

### Remote Mode (Production)

Connects directly to a Turso Cloud database over HTTP. Your data lives on Turso's global edge network.

```elixir
config :my_app, MyApp.Repo,
  uri: "libsql://your-db.turso.io",
  auth_token: System.get_env("TURSO_AUTH_TOKEN")
```

### Embedded Replica Mode (Edge)

Maintains a local SQLite file that automatically syncs with Turso Cloud. Reads are instant (local), writes sync to the cloud. Best latency characteristics.

```elixir
config :my_app, MyApp.Repo,
  database: "local_replica.db",
  uri: "libsql://your-db.turso.io",
  auth_token: System.get_env("TURSO_AUTH_TOKEN"),
  sync: true
```

## Additional Configuration

### Encryption

```elixir
config :my_app, MyApp.Repo,
  database: "encrypted.db",
  encryption_key: System.get_env("DB_ENCRYPTION_KEY")  # min 32 chars
```

## Mix Tasks

| Task | Description |
|------|-------------|
| `mix ash_turso.create` | Create the database |
| `mix ash_turso.drop` | Drop the database |
| `mix ash_turso.migrate` | Run pending migrations |
| `mix ash_turso.rollback` | Rollback migrations |
| `mix ash_turso.generate_migrations` | Generate migrations from Ash resources |
| `mix ash_turso.install` | Install AshTurso into an existing Ash project |

## Relationship to AshSqlite

AshTurso is a fork of [AshSqlite](https://github.com/ash-project/ash_sqlite), adapted to use `ecto_libsql` instead of `ecto_sqlite3`. Since libSQL is a fork of SQLite, the SQL dialect is identical. The key difference is the transport layer — `ecto_libsql` can talk to Turso Cloud databases over HTTP, while `ecto_sqlite3` only supports local files.

If you're migrating from AshSqlite, the changes are minimal:

1. Replace `AshSqlite.DataLayer` → `AshTurso.DataLayer`
2. Replace `AshSqlite.Repo` → `AshTurso.Repo`
3. Replace DSL section `sqlite do` → `turso do`
4. Update your repo config for your desired connection mode

## Documentation

- [Getting Started Guide](documentation/tutorials/getting-started-with-ash-turso.md)
- [HexDocs](https://hexdocs.pm/ash_turso)
- [Ash Framework](https://ash-hq.org)
- [Turso](https://turso.tech)
- [ecto_libsql](https://github.com/ocean/ecto_libsql)

## License

MIT — see [LICENSE](LICENSE) for details.
