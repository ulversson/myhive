defmodule MyHive.Chat.ConversationTitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
