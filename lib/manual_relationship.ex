# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.ManualRelationship do
  @moduledoc "A behavior for turso-specific manual relationship functionality"

  @callback ash_turso_join(
              source_query :: Ecto.Query.t(),
              opts :: Keyword.t(),
              current_binding :: term,
              destination_binding :: term,
              type :: :inner | :left,
              destination_query :: Ecto.Query.t()
            ) :: {:ok, Ecto.Query.t()} | {:error, term}

  @callback ash_turso_subquery(
              opts :: Keyword.t(),
              current_binding :: term,
              destination_binding :: term,
              destination_query :: Ecto.Query.t()
            ) :: {:ok, Ecto.Query.t()} | {:error, term}

  defmacro __using__(_) do
    quote do
      @behaviour AshTurso.ManualRelationship
    end
  end
end
