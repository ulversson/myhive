defmodule MyHiveWeb.UsersSearchController do
  use MyHiveWeb, :controller
  alias MyHive.Repo
  alias MyHive.Accounts
  alias MyHive.Accounts.User
  action_fallback MyHiveWeb.ApiFallbackController

  def index(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    users = Accounts.query_by_name(params["q"], current_user.id) |> Repo.all()
    render conn, :index, users: users
  end

  def for_select(conn, %{"ids" => ids})  do
    users = ids
      |> String.split(",")
      |> Enum.map(fn x -> String.trim(x)  end)
      |> Accounts.get_users_by_ids
      |> Enum.map(fn x -> %{first_name: x.first_name, last_name: x.last_name, id: x.id} end)
    conn |> json(users)
  end

  def for_select(conn, _)  do
    conn |> json([])
  end

  def all(conn, _params)  do
    users = Accounts.all_by_name()
    |> Enum.map(fn x -> %{first_name: x.first_name, last_name: x.last_name, id: x.id} end)
    conn |> json(users)
  end

end
