defmodule MyHiveWeb.Api.V1.BulkOperationController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager.{
    FileManagerHoover,
    FileManagerLabeler
  }
  action_fallback MyHiveWeb.ApiFallbackController

  def delete_all(conn, %{"selected" => selected}) do
    FileManagerHoover.call(selected)
    conn |> json(%{"success" => true})
  end

  def mark_all(conn, %{
    "selected" => selected, "marking" => marking}) do
    FileManagerLabeler.call(selected, marking, current_user(conn).id)
    conn |> json(%{"success" => true})
  end

  defp current_user(conn) do
    conn.private.guardian_default_resource
  end


end
