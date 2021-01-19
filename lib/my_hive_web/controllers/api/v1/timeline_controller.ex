defmodule MyHiveWeb.Api.V1.TimelineController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Repo,
    CaseManagement,
    MessageBoard
  }
  alias MyHive.CaseManagement.Services.TimelineOrganizer
  alias MyHiveWeb.FallbackController

  def create(conn, params) do
    case CaseManagement.create_medico_legal_case_status(params["medico_legal_case_id"], params["name"]) do
      _status ->
        statuses = CaseManagement.get_case_with_stages(params["medico_legal_case_id"])
        conn |> render("statuses.json", %{
          statuses: statuses
        })
    end
  end

  def patch(conn, %{"id" => id, "statuses" => statuses}) do
    TimelineOrganizer.call(statuses)
    statuses = CaseManagement.get_case_with_stages(id)
    conn |> render("statuses.json", %{
      statuses: statuses
    })
  end

  def update_status(conn, %{"id" => status_id, "name" => name}) do
    status_id
      |> CaseManagement.find_status_by_id()
      |> CaseManagement.update_medico_legal_case_status(%{name: name})
    conn |> json(%{"status" => true, "message" => "ok"})
  end

  def delete(conn, %{"id" => status_id}) do
    case CaseManagement.find_status_by_id(status_id) do
      nil ->
        conn
          |> put_status(422)
          |> json(%{success: false} )
      status ->
        Repo.transaction(fn ->
          Repo.delete(status)
          CaseManagement.recalculate_case_progress(status.medico_legal_case_id)
          MessageBoard.remove_comments(status.id, "MedicoLegalCaseStatus")
        end)
        conn |> json(%{
          "success" => true,
          "message" => "Timeline item removed",
          "status" => "ok"
        })
    end
  end

  def reset(conn, %{"id" => mlc_id}) do
    case CaseManagement.get_case_with_stages(mlc_id) do
      [] ->
        conn
        |> put_status(422)
        |> json(%{success: false} )
      statuses ->
        CaseManagement.reset_stages(statuses, mlc_id)
        conn |> json(%{
          "success" => true,
          "message" => "Timeline item removed",
          "status" => "ok"
        })
    end
  end

  def comments(conn, %{"id" => status_id}) do
    case MessageBoard.comments_for_item(status_id, "MedicoLegalCaseStatus") do
      nil ->
        conn |> FallbackController.call({:error, :not_found})
      comments ->
        conn |> render("comments.json", %{
          comments: comments
        })
    end
  end

  def delete_comment(conn, %{"id" => comment_id}) do
    MessageBoard.remove_comment(comment_id)
    conn |> json(%{"status" => "ok"})
  end

  def post_comment(conn, %{"id" => status_id, "comment" => comment}) do
    case MessageBoard.create_comment(%{
      commentable_id: status_id,
      commentable_type: "MedicoLegalCaseStatus",
      body: comment["body"],
      commented_at: Timex.now,
      commented_by: Guardian.Plug.current_resource(conn).id
    }) do
      {:ok, comment} ->
        comment = Repo.preload(comment, :user)
        conn |> render("comment.json", %{
          comment: comment
        })
      {:error, changeset} ->
       FallbackController.call(conn, {:error, changeset})
    end

  end
end
