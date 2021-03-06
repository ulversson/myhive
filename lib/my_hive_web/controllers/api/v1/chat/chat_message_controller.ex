defmodule MyHiveWeb.Api.V1.Chat.ChatMessageController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Chat, Repo
  }

  def show(conn, %{"slug" => slug}) do
    case Chat.conv_by_name(slug) do
      nil -> conn |> json([])
      conv ->
        Repo.preload(conv, :messages)
        conn |> render("messages.json",
          messages: slug.messages)
    end
  end
end
