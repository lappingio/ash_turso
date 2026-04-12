# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.Transformers.VerifyRepo do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def after_compile?, do: true

  def transform(dsl) do
    repo = Transformer.get_option(dsl, [:turso], :repo)

    cond do
      is_function(repo) ->
        {:ok, dsl}

      match?({:error, _}, Code.ensure_compiled(repo)) ->
        {:error, "Could not find repo module #{repo}"}

      repo.__adapter__() != Ecto.Adapters.LibSql ->
        {:error, "Expected a repo using the turso adapter `Ecto.Adapters.LibSql`"}

      true ->
        {:ok, dsl}
    end
  end
end
