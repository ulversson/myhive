defmodule MyHiveWeb.Api.V1.ReportController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Repo, Reports
  }
  alias MyHive.Reports.{
    UserReportProcessor,
    ReportHoover
  }

  def index(conn, %{"q" => q}) do
    reports = Reports.list_templates(q, true)
       |> Repo.preload(:sections)
    conn |> json(%{data: reports})
  end

  def save_sections(conn, %{"report" => report, "save_doc" => save_doc}) do
    user = conn.private.guardian_default_resource
    report = UserReportProcessor.call(report, user.id, save_doc)
    render(conn, "report.json", %{
      report: report
    })
  end

  def by_user_for_case(conn, %{"id" => mlc_id, "page" => page}) do
    user = conn.private.guardian_default_resource
    case Reports.by_user_for_case(page, user.id, mlc_id) do
      [] -> json(conn, [])
      data -> 
        conn |> render("user_reports.json", 
          reports: data.entries,
          page_number: data.page_number,
          page_size: data.page_size,
          total_entries: data.total_entries,
          total_pages: data.total_pages
        )
    end
  end

  def show(conn, %{"id" => report_id}) do 
    report = Reports.by_id(report_id)
    render(conn, "report.json", %{
      report: report
    }) 
  end

  def delete(conn, %{"id" => report_id}) do 
    user = conn.private.guardian_default_resource
    ReportHoover.call(report_id, user.id)
    conn |> json(%{
      "status" => true, "message" => "ok"
    })
  end

end
