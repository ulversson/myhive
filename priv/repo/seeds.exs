alias MyHive.Accounts.User
alias MyHive.Chat.Conversation
alias MyHive.Chat.ConversationMember

alias MyHive.{Accounts, Chat}

u1_id = 17
u2_id = 18
{:ok, %Conversation{id: conv_id}} = Chat.create_conversation(%{title: "Modern Talking"})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: u1_id, owner: true})

{:ok, %ConversationMember{}} =
  Chat.create_conversation_member(%{conversation_id: conv_id, user_id: u2_id, owner: false})
