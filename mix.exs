defmodule AshTurso.MixProject do
  use Mix.Project

  @description """
  The Turso/libSQL data layer for Ash Framework.
  """

  @version "0.1.1"

  def project do
    [
      app: :ash_turso,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      elixirc_paths: elixirc_paths(Mix.env()),
      cli: cli(),
      dialyzer: [
        plt_add_apps: [:ecto, :ash, :mix]
      ],
      docs: &docs/0,
      aliases: aliases(),
      package: package(),
      source_url: "https://github.com/lappingio/ash_turso",
      homepage_url: "https://github.com/lappingio/ash_turso",
      consolidate_protocols: Mix.env() != :test
    ]
  end

  defp cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.github": :test,
        "test.create": :test,
        "test.migrate": :test,
        "test.rollback": :test,
        "test.check_migrations": :test,
        "test.drop": :test,
        "test.generate_migrations": :test,
        "test.reset": :test
      ]
    ]
  end

  if Mix.env() == :test do
    def application() do
      [
        mod: {AshTurso.TestApp, []}
      ]
    end
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: [
        "Lapping IO <hello@lapping.io>"
      ],
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG* documentation),
      links: %{
        "GitHub" => "https://github.com/lappingio/ash_turso",
        "Changelog" => "https://github.com/lappingio/ash_turso/blob/main/CHANGELOG.md"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      extras: [
        {"README.md", title: "Home"},
        "documentation/tutorials/getting-started-with-ash-turso.md",
        "documentation/topics/about-ash-turso/what-is-ash-turso.md",
        "documentation/topics/about-ash-turso/transactions.md",
        "documentation/topics/resources/references.md",
        "documentation/topics/resources/polymorphic-resources.md",
        "documentation/topics/development/migrations-and-tasks.md",
        "documentation/topics/development/testing.md",
        "documentation/topics/advanced/expressions.md",
        "documentation/topics/advanced/manual-relationships.md",
        {"documentation/dsls/DSL-AshTurso.DataLayer.md",
         search_data: Spark.Docs.search_data_for(AshTurso.DataLayer)},
        "CHANGELOG.md"
      ],
      skip_undefined_reference_warnings_on: [
        "CHANGELOG.md"
      ],
      groups_for_extras: [
        Tutorials: [
          ~r'documentation/tutorials'
        ],
        "How To": ~r'documentation/how_to',
        Topics: ~r'documentation/topics',
        DSLs: ~r'documentation/dsls',
        "About AshTurso": [
          "CHANGELOG.md"
        ]
      ],
      groups_for_modules: [
        AshTurso: [
          AshTurso,
          AshTurso.Repo,
          AshTurso.DataLayer
        ],
        Utilities: [
          AshTurso.ManualRelationship
        ],
        Introspection: [
          AshTurso.DataLayer.Info,
          AshTurso.CustomExtension,
          AshTurso.CustomIndex,
          AshTurso.Reference,
          AshTurso.Statement
        ],
        Types: [
          AshTurso.Type
        ],
        Expressions: [
          AshTurso.Functions.Fragment,
          AshTurso.Functions.Like
        ],
        Internals: ~r/.*/
      ]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.13"},
      {:ecto_libsql, "~> 0.9"},
      {:ecto, "~> 3.13"},
      {:jason, "~> 1.0"},
      {:ash, ash_version("~> 3.19")},
      {:ash_sql, ash_sql_version("~> 0.2 and >= 0.2.20")},
      {:igniter, "~> 0.6 and >= 0.6.14", optional: true},
      {:simple_sat, ">= 0.0.0", only: [:dev, :test]},
      {:git_ops, "~> 2.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.37-rc", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.14", only: [:dev, :test]},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:sobelow, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:mix_audit, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp ash_version(default_version) do
    case System.get_env("ASH_VERSION") do
      nil -> default_version
      "local" -> [path: "../ash", override: true]
      "main" -> [git: "https://github.com/ash-project/ash.git", override: true]
      version when is_binary(version) -> "~> #{version}"
      version -> version
    end
  end

  defp ash_sql_version(default_version) do
    case System.get_env("ASH_SQL_VERSION") do
      nil -> default_version
      "local" -> [path: "../ash_sql", override: true]
      "main" -> [git: "https://github.com/ash-project/ash_sql.git"]
      version when is_binary(version) -> "~> #{version}"
      version -> version
    end
  end

  defp aliases do
    [
      sobelow:
        "sobelow --skip -i Config.Secrets --ignore-files lib/migration_generator/migration_generator.ex",
      credo: "credo --strict",
      docs: [
        "spark.cheat_sheets",
        "docs",
        "spark.replace_doc_links"
      ],
      "spark.formatter": "spark.formatter --extensions AshTurso.DataLayer",
      "spark.cheat_sheets": "spark.cheat_sheets --extensions AshTurso.DataLayer",
      "test.generate_migrations": "ash_turso.generate_migrations",
      "test.check_migrations": "ash_turso.generate_migrations --check",
      "test.migrate": "ash_turso.migrate",
      "test.rollback": "ash_turso.rollback",
      "test.create": "ash_turso.create",
      "test.reset": ["test.drop", "test.create", "test.migrate"],
      "test.drop": "ash_turso.drop"
    ]
  end
end
