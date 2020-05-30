defmodule MyHive.Accounts.UsernameSlug do
  use EctoAutoslugField.Slug,
    from: [:first_name, :last_name], to: :slug
end
