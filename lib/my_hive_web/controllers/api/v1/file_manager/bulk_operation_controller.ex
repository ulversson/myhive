defmodule MyHiveWeb.Api.V1.BulkOperationController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager.{
    FileManagerHoover,
    FileManagerLabeler,
    FileManagerMover
  }
  alias MyHive.CaseManagement
  action_fallback MyHiveWeb.ApiFallbackController

  def delete_all(conn, %{"selected" => selected}) do
    user_id = current_user(conn).id
    FileManagerHoover.soft_call(selected, user_id)
    conn |> json(%{"success" => true})
  end

  def mark_all(conn, %{
    "selected" => selected, "marking" => marking}) do
    FileManagerLabeler.call(selected, marking, current_user(conn).id)
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  def tidy_up(conn, %{"id" => medico_legal_case_id}) do
    CaseManagement.tidy_up_folders(medico_legal_case_id)
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  def move_all(conn, %{"selected" => selected, "id" => id}) do
    FileManagerMover.call(selected, id)
    conn |> json(%{"success" => true, "status" => "ok"})
  end

  defp current_user(conn) do
    conn.private.guardian_default_resource
  end

end
