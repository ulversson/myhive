defmodule MyHiveWeb.ConversationLive do
  use Phoenix.HTML
  alias MyHive.{Accounts, Chat, Repo}
  use Phoenix.LiveView, layout: {MyHiveWeb.LayoutView, "live.html"}

  def handle_params(%{"conversation_id" => conversation_id, "user_id" => user_id}, _uri, socket) do
    {:noreply,
      socket
      |> Phoenix.LiveView.assign(:user_id, user_id)
      |> Phoenix.LiveView.assign(:conversation_id, conversation_id)
      |> assign_records()
    }
  end

  def render(assigns) do
    ~L"""
    <div>
      <b>User name:</b> <%= @user.first_name %>
    </div>
    <div>
      <b>Conversation title:</b> <%= @conversation.title %>
    </div>
    <div>
      <%= f = form_for :message, "#", [phx_submit: "send_message"] %>
        <%= label f, :content %>
        <%= text_input f, :content %>
        <%= submit "Send" %>
      </form>
    </div>
    <div>
      <b>Messages:</b>
      <%= for message <- @messages do %>
        <div>
          <b><%= message.user.nickname %></b>: <%= message.content %>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event(
        "send_message",
        %{"message" => %{"content" => content}},
        %{assigns: %{conversation_id: conversation_id, user_id: user_id, user: user}} = socket
      ) do
    case Chat.create_message(%{
          conversation_id: conversation_id,
          user_id: user_id,
          content: content
        }) do
      {:ok, new_message} ->
        new_message = %{new_message | user: user}
        updated_messages = socket.assigns[:messages] ++ [new_message]

        {:noreply, socket |> Phoenix.LiveView.assign(:messages, updated_messages)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  defp assign_records(%{assigns: %{user_id: user_id, conversation_id: conversation_id}} = socket) do
    user = Accounts.get_user!(user_id)

    conversation =
      Chat.get_conversation!(conversation_id)
      |> Repo.preload(messages: [:user], conversation_members: [:user])

    socket
    |> Phoenix.LiveView.assign(:user, user)
    |> Phoenix.LiveView.assign(:conversation, conversation)
    |> Phoenix.LiveView.assign(:messages, conversation.messages)
  end
  def mount(assigns, socket) do

    {:ok, assign(socket, assigns),
    layout: {MyHiveWeb.LayoutView, "live.html"}}
  end
end