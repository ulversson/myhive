defmodule MyHiveWeb.Api.V1.Radiology.RadiologyBrowseController do
  use MyHiveWeb, :controller
  alias MyHive.Radiology.Services.OrthancClient
  alias MyHiveWeb.ApiFallbackController

  def index(conn, %{"patient" => patient}) do
    case OrthancClient.call(patient) do
      {:error, _} ->
        ApiFallbackController
         .call(conn, {:error, :unprocessable_entity})
      response ->
        json(conn, %{
          data: OrthancClient.simplify(response)
        })
    end
  end

end
