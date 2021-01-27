defmodule MyHive.Reports.ReportSectionsCreator do

  alias MyHive.Reports.{
    ReportSectionContent,
  }
  alias MyHive.Reports
  alias MyHive.Repo

  def call(sections, report_id, user_id) do
    sections
      |> Map.values
      |> Enum.with_index
      |> Enum.map(fn {section, index} ->
        db_section = Reports.find_section_by_id(section["report_section_id"])
        section_data = Map.merge(section, %{
          "user_id" => user_id,
          "order" => index,
          "user_report_id" => report_id,
          "header" => "#{db_section.letter}#{index+1}"
        })
        %ReportSectionContent{}
          |> ReportSectionContent.changeset(section_data)
          |> Repo.insert()
          |> elem(1)
      end)
  end
end
