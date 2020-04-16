defmodule MyHiveWeb.UserLive.Edit do
  use Phoenix.LiveView
  alias MyHiveWeb.UserLive.CommonUser
  alias MyHiveWeb.UserLive
  alias MyHiveWeb.UserView
  alias MyHiveWeb.Router.Helpers, as: Routes
  alias MyHive.Accounts
  alias MyHiveWeb.UserLive.CommonUser
  def mount(params, session, socket) do
    user = Accounts.get_user!(params["id"])

    {:ok,
     assign(socket, %{
       user: user,
       changeset: Accounts.change_user(user),
       current_user: CommonUser.get_current_user(session)
     })}
  end

  def render(assigns), do: UserView.render("edit.html", assigns)

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(params)
      |> Map.put(:action, :update)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Map.put(user_params, "roles", [user_params["roles"]])
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply, push_redirect(
          socket|> put_flash(:info, "User created successfully."),
        to: Routes.user_path(MyHiveWeb.Endpoint, :index)
      )}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
