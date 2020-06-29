defmodule MyHive.Blog.BlogSearch do
  import Ecto.Query
  alias MyHive.Repo

  def run(query, search_string) do
    _run(query, normalize(search_string))
  end

  defmacro matching_recipe_ids_and_ranks(search_string) do
    quote do
      fragment(
        """
        SELECT blog_posts.id AS id,
        ts_rank_cd(
          to_tsvector(blog_posts.body), plainto_tsquery(unaccent(?))
        ) AS rank
        FROM blog_posts
        WHERE blog_posts.body @@ plainto_tsquery(unaccent(?))
        OR blog_posts.title ILIKE ?
        """,
        ^unquote(search_string),
        ^unquote(search_string),
        ^"%#{unquote(search_string)}%"
      )
    end
  end

  defp _run(query, ""), do: query
  defp _run(query, search_string) do
    query = from post in query,
      join: id_and_rank in matching_recipe_ids_and_ranks(search_string),
      on: id_and_rank.id == post.id,
      order_by: [desc: id_and_rank.rank]
    Repo.all(query)
  end

  defp normalize(search_string) do
    search_string
    |> String.downcase
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
  end

end
