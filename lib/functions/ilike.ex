# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.Functions.ILike do
  @moduledoc """
  Maps to the builtin turso function `ilike`.
  """

  use Ash.Query.Function, name: :ilike

  def args, do: [[:string, :string]]
end
