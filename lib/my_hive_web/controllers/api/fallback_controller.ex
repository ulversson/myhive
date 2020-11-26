defmodule MyHiveWeb.ApiFallbackController do
  use MyHiveWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{
      type: "error",
      error: ["You are not authorized to perform this action"]
    })
    |> halt()
  end

  def call(conn, {:error, :restore_folder_not_found}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{
      type: "error",
      error: ["The folder for this file does not exist anymore"]
    })
    |> halt()
  end

  def call(conn, {:error, :restore_error_with_case}) do
    conn
    |> put_status(422)
    |> json(%{
      type: "error",
      error: ["This item could not be restored to its original location. The corresponding case have been deleted"]
    })
    |> halt()
  end

  def call(conn, {:error, :restore_error_no_root}) do
    conn
    |> put_status(422)
    |> json(%{
      type: "error",
      error: ["This item could not be restored to its original location. Its parent folder has been deleted"]
    })
    |> halt()
  end

  def call(conn, {:error, :error_restore_not_all}) do
    conn
    |> put_status(422)
    |> json(%{
      type: "warning",
      error: ["Some of the items were not restored becuase their original location no longer exists"]
    })
    |> halt()
  end

end
