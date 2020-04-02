defmodule MyHiveWeb.ApiFallbackController do
  use MyHiveWeb, :controller  
  
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{
      error: ["You are not authorized to perform this action"]
    })
    |> halt()
  end


end