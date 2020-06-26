defmodule MyHive.Blog.PostTitleSlug do
  use EctoAutoslugField.Slug,
    from: [:title], to: :slug
end
