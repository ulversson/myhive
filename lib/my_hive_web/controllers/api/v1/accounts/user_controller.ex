defmodule MyHiveWeb.Api.V1.Accounts.UserController do
  use MyHiveWeb, :controller
  alias MyHive.Chat

  def index(conn, %{"conversation" => conv}) do
    user = conn.private.guardian_default_resource
    users = Chat.conversation_members(user.id, conv)
    conversation = Chat.conv_by_name(conv)
    conn |> render(
      "index.json",
      users: users,
      conv: conversation
    )
  end
end
