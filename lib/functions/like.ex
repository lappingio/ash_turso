# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.Functions.Like do
  @moduledoc """
  Maps to the builtin turso function `like`.
  """

  use Ash.Query.Function, name: :like

  def args, do: [[:string, :string]]
end
