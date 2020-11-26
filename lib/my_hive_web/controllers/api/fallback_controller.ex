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

  def call(conn, {:error, :restore_folder_not_found}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{
      error: ["The folder for this file does not exist anymore"]
    })
    |> halt()
  end

  def call(conn, {:error, :restore_error_with_case}) do
    conn
    |> put_status(422)
    |> json(%{
      error: ["This item could not be restored to its original location. The corresponding case have been deleted"]
    })
    |> halt()
  end

  def call(conn, {:error, :restore_error_no_root}) do
    conn
    |> put_status(422)
    |> json(%{
      error: ["This item could not be restored to its original location. Its parent folder has been deleted"]
    })
    |> halt()
  end

end
