defmodule MyHiveWeb.Api.V1.TimelineView do
  use MyHiveWeb, :view
  alias MyHiveWeb.{
    MedicoLegalCaseView,
    CommentView
  }

  def render("statuses.json", %{statuses: statuses}) do
    render_one(statuses, MedicoLegalCaseView, "statuses.json", %{statuses: statuses})
  end

  def render("comment.json", %{comment: comment}) do
    render_one(comment, CommentView, "comment.json", %{comment: comment})
  end

  def render("comments.json", %{comments: comments}) do
    %{
      data: render_many(comments, CommentView, "comment.json", as: :comment)
    }
  end


end
