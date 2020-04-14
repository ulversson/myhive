defmodule MyHiveWeb.Plugs.AuthorizationPlug do
  @moduledoc """
  This plug ensures that a user has a particular role.

  ## Example

      plug MyHiveWeb.Plugs.AuthorizationPlug, [:admin, :teacher]

      plug MyHiveWeb.Plugs.AuthorizationPlug, :teacher

      plug MyHiveWeb.Plugs.AuthorizationPlug, ~w(student teacher)a
  """

  def init(config), do: config

  def call(conn, roles) do
    current_user = conn.private.guardian_default_resource
    current_user
    |> has_role?(roles)
    |> maybe_halt(conn)
  end

  defp has_role?(nil, _roles), do: false

  defp has_role?(user, roles) when is_list(roles) do
    allowed_roles  = Enum.map(roles, fn r -> Atom.to_string(r) end)
    Enum.any?(allowed_roles, fn x -> x in user.roles end)
  end

  defp has_role?(user, role) when is_atom(role) do
    Enum.member?(user.roles, Atom.to_string(role))
  end

  defp has_role?(%{role: role}, role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn

  defp maybe_halt(_any, conn) do
    conn |> MyHiveWeb.ApiFallbackController.call({:error, :unauthorized})
  end
end
