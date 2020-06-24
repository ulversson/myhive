defmodule MyHiveWeb.TimeSheet.ExportController do
  use MyHiveWeb, :controller
  alias MyHive.TimeSheet
  alias MyHive.TimeSheet.Services.PdfRenderer
  alias MyHive.TimeSheet.Services.XLSXRenderer

  def pdf(conn, %{"ids" => ids}) do
    time_entries = get_time_entries(ids)
    case PdfRenderer.call(time_entries) do
      {:ok, pdf_file} ->
        conn
          |> send_download(
            {:file, pdf_file},
            filename: "Export_#{PdfRenderer.timestamp()}.pdf",
            content_type: "application/pdf",
            disposition: :attachment,
            charset: "utf-8"
          )
      {:error, _} ->
        conn
        |> put_flash(:error, "Could not download this pdf")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def xlsx(conn, %{"ids" => ids}) do
    entries = get_time_entries(ids)
    conn
      |> put_resp_content_type("text/xlsx")
      |> put_resp_header("content-disposition", content_disp_header())
      |> render("export.xlsx", %{entries: entries})
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
