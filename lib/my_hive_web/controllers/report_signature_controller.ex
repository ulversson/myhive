defmodule MyHiveWeb.ReportSignatureController do
  use MyHiveWeb, :controller
  
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}

  alias MyHive.Accounts.{
    UserReportSignatureUploader,
    UserReportSignatureHoover
  }

  def create(conn, %{"files" => files} = params) do 
    user_id = get_user_id(conn, params)
    UserReportSignatureUploader.call(files, user_id)
    conn |> send_resp(201, "")
  end

  def update(conn, %{"id" => id, "content" => content}) do 
    user_id = if id == "me", do: conn.assigns.current_user.id, else: id
    UserReportSignatureUploader.call(content, user_id)
    conn |> json(%{
      "status" =>  "ok",
      "message" => "Signature updated"
    })
  end

  def delete(conn, %{"id" => item_id} = params) do 
    user_id = get_user_id(conn, params)
    UserReportSignatureHoover.call(user_id)
    conn |> json(%{
      "status" =>  "ok",
      "message" => "Signature removed"
    })
  end

  defp get_user_id(conn, params) do 
    if is_nil(params["id"]), do: conn.assigns.current_user.id, else: params["id"]
  end
end
