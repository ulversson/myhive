defmodule MyHiveWeb.Api.V1.ReportView do

  use MyHiveWeb, :view
  alias MyHive.Accounts.User

  def render("user_reports.json", %{
      reports: user_reports,
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }) do
    %{
      data: Enum.map(user_reports, fn rep -> report_data(rep) end),
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }
  end

  def render("report.json", %{report: report}) do
    report_data(report)
  end

  defp report_data(report) do
    rtemp = MyHive.Repo.preload(report.report_template, [:sections,:report_sections])
    %{
      id: report.id,
      updated_at: report.updated_at,
      file_asset_id: report.file_asset_id,
      folder_id: report.folder_id,
      medico_legal_case_id: report.medico_legal_case_id,
      user: %{
        name: User.name_for(report.user),
        id: report.user_id,
        code: report.report_template.code
      },
      folder: report.folder_id,
      report_template: %{
        sections: rtemp.sections,
        report_sections: rtemp.report_sections,
        code: report.report_template.code,
        name: report.report_template.name,
        id: report.report_template_id
      },
      report_section_contents: render_sections(report.report_section_contents)
    }
  end


  defp render_sections(sections) do
    Enum.map(sections, fn sec ->  section_json(sec) end)
  end

  defp section_json(section) do
    %{
      content: section.content,
      header: section.header,
      order: section.order
    }
  end
end
