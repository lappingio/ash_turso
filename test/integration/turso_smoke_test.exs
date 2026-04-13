defmodule AshTurso.Integration.Repo do
  use AshTurso.Repo, otp_app: :ash_turso
end

defmodule AshTurso.Integration.Post do
  use Ash.Resource,
    domain: AshTurso.Integration.Domain,
    data_layer: AshTurso.DataLayer,
    validate_domain_inclusion?: false

  turso do
    repo AshTurso.Integration.Repo
    table "integration_posts"
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
  end

  actions do
    defaults [:read, create: [:title]]
  end
end

defmodule AshTurso.Integration.Domain do
  use Ash.Domain, validate_config_inclusion?: false

  resources do
    resource AshTurso.Integration.Post
  end
end

defmodule AshTurso.Integration.TursoSmokeTest do
  use ExUnit.Case, async: false

  @moduletag :integration

  setup_all do
    database_url = System.get_env("TURSO_DATABASE_URL")
    auth_token = System.get_env("TURSO_AUTH_TOKEN")

    if is_nil(database_url) or is_nil(auth_token) do
      raise "TURSO_DATABASE_URL and TURSO_AUTH_TOKEN must be set for integration tests"
    end

    Application.put_env(:ash_turso, AshTurso.Integration.Repo,
      uri: database_url,
      auth_token: auth_token,
      pool_size: 2,
      stacktrace: true,
      show_sensitive_data_on_connection_error: true
    )

    {:ok, _pid} = start_supervised(AshTurso.Integration.Repo)

    Ecto.Adapters.SQL.query!(AshTurso.Integration.Repo, """
    CREATE TABLE IF NOT EXISTS integration_posts (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL
    )
    """)

    :ok
  end

  setup do
    Ecto.Adapters.SQL.query!(AshTurso.Integration.Repo, "DELETE FROM integration_posts")
    :ok
  end

  test "can create and read records through AshTurso data layer" do
    created =
      AshTurso.Integration.Post
      |> Ash.Changeset.for_create(:create, %{title: "hello turso"})
      |> Ash.create!(domain: AshTurso.Integration.Domain)

    records = Ash.read!(AshTurso.Integration.Post, domain: AshTurso.Integration.Domain)

    assert Enum.any?(records, &(&1.id == created.id and &1.title == "hello turso"))
  end
end
