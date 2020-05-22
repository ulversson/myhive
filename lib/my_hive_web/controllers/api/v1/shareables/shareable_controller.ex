defmodule MyHiveWeb.Api.V1.Shareables.ShareableController do
  use MyHiveWeb, :controller
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
end
