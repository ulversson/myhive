defmodule MyHiveWeb.UserLive.New do
  use Phoenix.LiveView
  alias MyHiveWeb.UserView
  alias MyHiveWeb.Router.Helpers, as: Routes
  alias MyHive.Accounts
  alias MyHive.Accounts.{User}
  alias MyHive.Emails.ConfirmationInstructionsEmail

  def mount(_params, _session, socket) do
    {:ok,
    assign(socket, %{
      changeset: Accounts.change_user(%User{})
      }),
      layout: {MyHiveWeb.LayoutView, "live.html"}}
  end

  def render(assigns) do
    UserView.render("new.html", assigns)
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Map.put(user_params, "roles", [user_params["roles"]])
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        ConfirmationInstructionsEmail.deliver(user)
        {:noreply, push_redirect(socket,
          to: Routes.user_path(MyHiveWeb.Endpoint, :index))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
