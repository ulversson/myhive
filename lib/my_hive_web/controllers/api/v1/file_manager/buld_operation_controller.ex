defmodule MyHiveWeb.Api.V1.BulkOperationController do
  use MyHiveWeb, :controller
  alias MyHive.FileManager.FileManagerHoover
  action_fallback MyHiveWeb.ApiFallbackController

  def delete_all(conn, %{"selected" => selected}) do
    FileManagerHoover.call(selected)
    conn |> json(%{"success" => true})
  end


end
