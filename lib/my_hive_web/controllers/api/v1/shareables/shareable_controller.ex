defmodule MyHiveWeb.Api.V1.Shareables.ShareableController do
  use MyHiveWeb, :controller
  alias MyHive.Shareable
  alias MyHive.Shareable.SharingDirectoryProcessor
  alias MyHiveWeb.ApiFallbackController

  action_fallback MyHiveWeb.ApiFallbackController

  def index(conn, %{"id" => mlc_id}) do
    dirs = Shareable.shared_for_mlc(mlc_id)
    case dirs do
      [] -> json(conn, [])
      dirs -> render(conn, "directories.json", %{
        dirs: dirs
      })
    end
  end

  def create(conn, %{"directory" => params}) do
    current_user = conn.private.guardian_default_resource
    case Shareable.create_shared_directory(params, current_user.id) do
      {:ok, directory} ->
        SharingDirectoryProcessor.call(current_user.id, directory)
        conn |>  json(%{"success" => true})
      {:error, _changeset}
        ->
        conn |> ApiFallbackController.call({:error, :unauthorized})
    end
  end

  def resend(conn, %{"id" => dir_id}) do
    current_user = conn.private.guardian_default_resource
    case Shareable.get_directory!(dir_id) do
      nil -> ApiFallbackController.call(conn, {:error, :not_found})
      dir ->
        SharingDirectoryProcessor.call(current_user.id, dir.id, :resend)
        conn |> json(%{
          "status" => "ok", "message" => "Email has been sent"
        })
    end
  end

  def delete(conn, %{"id" => dir_id}) do
    Shareable.remove!(dir_id)
     conn |> json(%{
        "status" => "ok", "message" => "Shared files access has been revoked"
      })
  end
end
