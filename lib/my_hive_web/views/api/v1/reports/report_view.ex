defmodule MyHiveWeb.Api.V1.ReportView do

  use MyHiveWeb, :view
  alias MyHive.Accounts.User
  alias MyHive.Repo

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
    medico_legal_case = MyHive.Repo.preload(report.medico_legal_case, [:patient])
    %{
      id: report.id,
      updated_at: report.updated_at,
      file_asset_id: report.file_asset_id,
      folder_id: report.folder_id,
      medico_legal_case_id: report.medico_legal_case_id,
      patient_last_name: medico_legal_case.patient.last_name,
      user: %{
        name: User.name_for(report.user),
        id: report.user_id,
        first_name: report.user.first_name,
        last_name: report.user.last_name,
        code: report.report_template.code
      },
      folder: report.folder_id,
      report_template: %{
        sections: rtemp.sections,
        report_sections: report_sections(rtemp.report_sections),
        code: report.report_template.code,
        name: report.report_template.name,
        id: report.report_template_id
      },
      glossary_of_terms: taggable_items(report.report_glossary_of_terms),
      report_section_contents: render_sections(report.report_section_contents)
    }
  end

  defp taggable_items(items) do 
    Enum.map(items, fn item -> glossary_item(item) end)
  end

  defp glossary_item(item) do 
    %{
      id: item.id, 
      description: item.content, 
      user_medico_legal_case_report_id: item.user_medico_legal_case_report_id,
      glossary_item: %{
        id: item.glossary_of_term.id,
        name: item.glossary_of_term.name,
        short_name: item.glossary_of_term.short_name,
        description: item.glossary_of_term.description
      }
    }
  end

  defp render_sections(sections) do
    Enum.map(sections, fn sec ->  section_json(sec) end)
  end

  defp section_json(section) do
    %{
      section_id: section.report_section_id,
      content: section.content,
      header: String.replace(section.header,~r/\d/, ""), 
      order: section.order, 
      timestamp: section.timestamp,
      occurred_on: section.occurred_on
    }
  end

  defp report_sections(report_sections) do 
    Enum.map(report_sections, fn sec -> report_section_json(sec) end)
  end

  defp report_section_json(sec) do
    sec = Repo.preload(sec, :report_section)
    %{
      report_template_id: sec.report_template_id,
      report_section_id: sec.report_section_id,
      is_multiple: sec.is_multiple,
      has_timestamp: sec.has_timestamp,
      is_taggable: sec.is_taggable,
      is_optional: sec.is_optional,
      default_content: sec.default_content,
      report_section: sec.report_section,
      order: sec.order,
      id: sec.id
    } 
  end
end
