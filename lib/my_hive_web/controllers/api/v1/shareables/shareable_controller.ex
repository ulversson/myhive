defmodule MyHiveWeb.Api.V1.Shareables.ShareableController do
  use MyHiveWeb, :controller
  alias MyHiveWeb.Endpoint
  alias MyHive.Shareable
  alias MyHive.Shareable.SharingDirectoryProcessor
  alias MyHiveWeb.ApiFallbackController

  action_fallback MyHiveWeb.ApiFallbackController
  def create(conn, %{"directory" => params}) do
    current_user = conn.private.guardian_default_resource
    case Shareable.create_shared_directory(params, current_user.id) do
      {:ok, directory} ->
        SharingDirectoryProcessor.call(directory)
        conn |>  json(%{"success" => true})
      {:error, _changeset}
        ->
        conn |> ApiFallbackController.call({:error, :unauthorized})
    end
  end

  def grant(conn, %{"id" => id}) do
    case Shareable.get_directory!(id) do
      nil ->
        conn
        |> put_status(422)
        |> json(%{"success" => false})
      directory ->
        Shareable.grant_access(directory)
        Endpoint.broadcast!("notifications:#{directory.token}",
          "access_granted", %{
            is_granted: true,
            for: directory.token
          })
        conn |>
          json(%{"success" => true})
    end
  end

end
