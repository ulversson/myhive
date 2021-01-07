defmodule MyHive.MessageBoard do
  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.MessageBoard.Comment

  def create_comment(params \\ %{}) do
    %Comment{}
      |> Comment.changeset(params)
      |> Repo.insert()
  end

  def comments_for_item(commentable_id, commentable_type) do
    query = comments_for_item_query(commentable_id, commentable_type)
    Repo.all(query)
  end

  def remove_comment(comment_id) do
    comment = Repo.get_by!(Comment, id: comment_id)
    Repo.delete(comment)
  end

  def remove_comments(commentable_id, commentable_type) do
    comments = comments_for_item(commentable_id, commentable_type)
    Enum.each(comments, fn comment ->
      Repo.delete(comment)
    end)
  end

  defp comments_for_item_query(commentable_id, commentable_type) do
    from c in Comment,
    where: c.commentable_id == ^commentable_id
      and c.commentable_type == ^commentable_type,
    order_by: [{:asc, :commented_at}],
    preload: [:user]
  end


end
