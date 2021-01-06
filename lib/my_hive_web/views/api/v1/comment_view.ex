defmodule MyHiveWeb.CommentView do
  use MyHiveWeb, :view
  alias MyHive.Accounts.User

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      type: comment.commentable_type,
      user: User.name_for(comment.user),
      user_id: comment.commented_by,
      commented_at: comment.commented_at,
      content: comment.body,
      avatar: User.chat_avatar(comment.user),
      parent_id: comment.parent_id
    }
  end

end
