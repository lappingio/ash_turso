# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.DataLayer.Info do
  @moduledoc "Introspection functions for "

  alias Spark.Dsl.Extension

  @doc "The configured repo for a resource"
  def repo(resource, type \\ :mutate) do
    case Extension.get_opt(resource, [:turso], :repo, nil, true) do
      fun when is_function(fun, 2) ->
        fun.(resource, type)

      repo ->
        repo
    end
  end

  @doc "The configured table for a resource"
  def table(resource) do
    Extension.get_opt(resource, [:turso], :table, nil, true)
  end

  @doc "The configured references for a resource"
  def references(resource) do
    Extension.get_entities(resource, [:turso, :references])
  end

  @doc "The configured reference for a given relationship of a  resource"
  def reference(resource, relationship) do
    resource
    |> Extension.get_entities([:turso, :references])
    |> Enum.find(&(&1.relationship == relationship))
  end

  @doc "A keyword list of customized migration types"
  def migration_types(resource) do
    Extension.get_opt(resource, [:turso], :migration_types, [])
  end

  @doc "A keyword list of customized migration defaults"
  def migration_defaults(resource) do
    Extension.get_opt(resource, [:turso], :migration_defaults, [])
  end

  @doc "A list of attributes to be ignored when generating migrations"
  def migration_ignore_attributes(resource) do
    Extension.get_opt(resource, [:turso], :migration_ignore_attributes, [])
  end

  @doc "The configured custom_indexes for a resource"
  def custom_indexes(resource) do
    Extension.get_entities(resource, [:turso, :custom_indexes])
  end

  @doc "The configured custom_statements for a resource"
  def custom_statements(resource) do
    Extension.get_entities(resource, [:turso, :custom_statements])
  end

  @doc "The configured polymorphic_reference_on_delete for a resource"
  def polymorphic_on_delete(resource) do
    Extension.get_opt(resource, [:turso, :references], :polymorphic_on_delete, nil, true)
  end

  @doc "The configured polymorphic_reference_on_update for a resource"
  def polymorphic_on_update(resource) do
    Extension.get_opt(resource, [:turso, :references], :polymorphic_on_update, nil, true)
  end

  @doc "The configured polymorphic_reference_name for a resource"
  def polymorphic_name(resource) do
    Extension.get_opt(resource, [:turso, :references], :polymorphic_on_delete, nil, true)
  end

  @doc "The configured polymorphic? for a resource"
  def polymorphic?(resource) do
    Extension.get_opt(resource, [:turso], :polymorphic?, nil, true)
  end

  @doc "The configured unique_index_names"
  def unique_index_names(resource) do
    Extension.get_opt(resource, [:turso], :unique_index_names, [], true)
  end

  @doc "The configured exclusion_constraint_names"
  def exclusion_constraint_names(resource) do
    Extension.get_opt(resource, [:turso], :exclusion_constraint_names, [], true)
  end

  @doc "The configured identity_index_names"
  def identity_index_names(resource) do
    Extension.get_opt(resource, [:turso], :identity_index_names, [], true)
  end

  @doc "Identities not to include in the migrations"
  def skip_identities(resource) do
    Extension.get_opt(resource, [:turso], :skip_identities, [], true)
  end

  @doc "The configured foreign_key_names"
  def foreign_key_names(resource) do
    Extension.get_opt(resource, [:turso], :foreign_key_names, [], true)
  end

  @doc "Whether or not the resource should be included when generating migrations"
  def migrate?(resource) do
    Extension.get_opt(resource, [:turso], :migrate?, nil, true)
  end

  @doc "A list of keys to always include in upserts."
  def global_upsert_keys(resource) do
    Extension.get_opt(resource, [:turso], :global_upsert_keys, [])
  end

  @doc "A stringified version of the base_filter, to be used in a where clause when generating unique indexes"
  def base_filter_sql(resource) do
    Extension.get_opt(resource, [:turso], :base_filter_sql, nil)
  end

  @doc "Skip generating unique indexes when generating migrations"
  def skip_unique_indexes(resource) do
    Extension.get_opt(resource, [:turso], :skip_unique_indexes, [])
  end

  @doc "Whether the migration generator should create a strict table"
  def strict?(resource) do
    Extension.get_opt(resource, [:turso], :strict?, false)
  end
end
