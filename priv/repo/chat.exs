alias MyHive.Accounts.User
alias MyHive.Chat.Conversation
alias MyHive.Chat.ConversationMember

alias MyHive.{Accounts, Chat}
{:ok, lobby_owner} = Accounts.get_by_email("admin@example.net")

{:ok, %Conversation{id: conv_id}} = Chat.create_conversation(%{title: "myHive Lobby"})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: lobby_owner.id, owner: true})

users = Accounts.all_by_name(lobby_owner.id)
Enum.each(users, fn user ->
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: user.id, owner: false})
end)
