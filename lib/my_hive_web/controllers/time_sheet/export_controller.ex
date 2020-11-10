defmodule MyHiveWeb.TimeSheet.ExportController do
  use MyHiveWeb, :controller
  alias MyHive.{
    TimeSheet, Repo
  }
  alias MyHive.TimeSheet.Services.PdfRenderer

  def pdf(conn, %{"ids" => ids} = params) do
    is_ext = params["extended"] == "true"
    time_entries = get_time_entries(ids) |> Repo.preload(:owner)
    case PdfRenderer.call(time_entries, is_ext) do
      {:ok, pdf_file} ->
        conn
          |> send_download(
            {:file, pdf_file},
            filename: "Export_#{PdfRenderer.timestamp()}.pdf",
            content_type: "application/pdf",
            encode: false,
            disposition: :attachment,
            charset: "utf-8"
          )
      {:error, _} ->
        conn
        |> put_flash(:error, "Could not download this pdf")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def xlsx(conn, %{"ids" => ids} = params) do
    is_ext = params["extended"] == "true"
    time_entries = get_time_entries(ids) |> Repo.preload(:owner)
    conn
      |> put_resp_content_type("text/xlsx")
      |> put_resp_header("content-disposition", content_disp_header())
      |> render("export.xlsx", %{entries: time_entries, extended: is_ext})
  end

  defp get_time_entries(ids) do
    ids
      |> String.split(",")
      |> TimeSheet.entries_by_ids()
  end

  defp content_disp_header() do
    "attachment;filename=Export_#{PdfRenderer.timestamp()}.xlsx"
  end
end
