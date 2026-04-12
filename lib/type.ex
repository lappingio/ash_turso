# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.Type do
  @moduledoc """
  Turso specific callbacks for `Ash.Type`.

  Use this in addition to `Ash.Type`.
  """

  @callback value_to_turso_default(Ash.Type.t(), Ash.Type.constraints(), term) ::
              {:ok, String.t()} | :error

  defmacro __using__(_) do
    quote do
      @behaviour AshTurso.Type
      def value_to_turso_default(_, _, _), do: :error

      defoverridable value_to_turso_default: 3
    end
  end
end
