# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.Transformers.ValidateReferences do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def after_compile?, do: true

  def transform(dsl) do
    dsl
    |> AshTurso.DataLayer.Info.references()
    |> Enum.each(fn reference ->
      unless Ash.Resource.Info.relationship(dsl, reference.relationship) do
        raise Spark.Error.DslError,
          path: [:turso, :references, reference.relationship],
          module: Transformer.get_persisted(dsl, :module),
          message:
            "Found reference configuration for relationship `#{reference.relationship}`, but no such relationship exists"
      end
    end)

    {:ok, dsl}
  end
end
