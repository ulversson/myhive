defmodule MyHiveWeb.Api.V1.Chat.ChatRoomView do
  use MyHiveWeb, :view

  def render("conversations.json", %{convs: convs}) do
   %{
      data: Enum.map(convs, &room_json/1),
    }
   end
   def room_json(room) do
    %{
      id: room.id,
      title: room.title,
      slug: room.slug
    }
  end

end
