# SPDX-FileCopyrightText: 2024 AshTurso contributors <https://github.com/lappingio/ash_turso/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshTurso.CustomExtension do
  @moduledoc """
  A custom extension implementation.
  """

  @callback install(version :: integer) :: String.t()

  @callback uninstall(version :: integer) :: String.t()

  defmacro __using__(name: name, latest_version: latest_version) do
    quote do
      @behaviour AshTurso.CustomExtension

      @extension_name unquote(name)
      @extension_latest_version unquote(latest_version)

      def extension, do: {@extension_name, @extension_latest_version, &install/1, &uninstall/1}
    end
  end
end
