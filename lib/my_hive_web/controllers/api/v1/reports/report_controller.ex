defmodule MyHiveWeb.Api.V1.ReportController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Repo, Reports, Accounts
  }
  alias MyHive.Reports.{
    UserReportProcessor,
    ReportHoover,
    UserReportUpdateProcessor
  }

  def index(conn, %{"q" => q}) do
    reports = Reports.list_templates(q, true)
    reports = Enum.map(reports, fn rep -> 
      rep = Map.put(rep, :report_sections, Enum.sort_by(rep.report_sections, &(&1.order)))
      Repo.preload(rep,  [{:report_sections, :report_section}])
    end)
    conn |> json(%{data: reports})
  end

  def save_sections(conn, %{"report" => report, "draft" => draft}) do
     case UserReportProcessor.call(report, draft) do 
      false ->
        conn 
          |> send_resp(422, "")
      report -> 
        render(conn, "report.json", %{
          report: report
        })
     end
  end

  def update_sections(conn, %{"report" => report, "draft" => _}) do
    report = UserReportUpdateProcessor.call(report)
    render(conn, "report.json", %{
      report: report
    })
  end

  def by_user_for_case(conn, %{"id" => mlc_id, "page" => page}) do
    user = conn.private.guardian_default_resource
    reports = if Accounts.is_admin_or_super_admin?(user) do 
      Reports.reports_for_case(page, mlc_id) 
    else
      Reports.by_user_for_case(page, user.id, mlc_id) 
    end
    case reports do
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

  def draft(conn, %{"report" => report, "id" => unique_key}) do
     case UserReportProcessor.call(report, false, unique_key) do 
      false ->
        conn 
          |> send_resp(422, "")
      report -> 
        render(conn, "report.json", %{
          report: report
        })
     end
  end

  def load_draft(conn, %{"mlc_id" => mlc_id, "user_id" => user_id, "template_id" => template_id}) do
    case Reports.last_draft(user_id, mlc_id, template_id) do 
      false ->
        conn 
          |> send_resp(422, "")
      report -> 
        render(conn, "report.json", %{
          report: report
        })
    end
  end
 
  def delete(conn, %{"id" => report_id}) do 
    user = conn.private.guardian_default_resource
    ReportHoover.call(report_id, user.id)
    conn |> json(%{
      "status" => true, "message" => "ok"
    })
  end

end
