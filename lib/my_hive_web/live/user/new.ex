defmodule MyHiveWeb.UserLive.New do
  use Phoenix.LiveView
  alias MyHiveWeb.UserView
  alias MyHiveWeb.Router.Helpers, as: Routes
  alias MyHive.Accounts.{ User }
  alias MyHive.Emails.ConfirmationInstructionsEmail
  alias MyHiveWeb.UserLive.CommonUser
  alias MyHive.{
    Saas, Accounts, Chat, Organizer
  }
  def mount(_params, session, socket) do
    {:ok,
    assign(socket, %{
        changeset: Accounts.change_user(%User{}),
        current_user: CommonUser.get_current_user(session),
        account_id: session["account_id"]
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

  def handle_event("save", %{"user" => user_params} = params, socket) do
    user_params = Map.put(user_params, "roles", [user_params["roles"]])
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        ConfirmationInstructionsEmail.deliver(user)
        Saas.add_to_account(user, params["account_id"])
        Chat.add_to_lobby(user.id)
        Organizer.create_calendar_for_user(user, %{name: "#{User.name_for(user)}'s Calendar"})
        {:noreply, push_redirect(socket,
          to: Routes.user_path(MyHiveWeb.Endpoint, :index))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
