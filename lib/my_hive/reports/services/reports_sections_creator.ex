defmodule MyHive.Reports.ReportSectionsCreator do

  alias MyHive.Reports.{
    ReportSectionContent,
  }
  alias MyHive.Reports
  alias MyHive.Repo

  def call(sections, report_id, user_id) do
    sections
      |> Enum.map(fn {section_id, section} ->
        section_map = Map.values(section) |> List.first
        Enum.map(section_map, fn {order, sec}  -> 
          db_section = Reports.find_section_by_id(sec["report_section_id"])
          section_data = Map.merge(sec, %{
            "user_id" => user_id,
            "order" => order,
            "user_report_id" => report_id,
            "header" => db_section.letter,
            "occurred_on" => sec["occurred_on"],
            "timestamp" => sec["timestamp"]
          })
          %ReportSectionContent{}
            |> ReportSectionContent.changeset(section_data)
            |> Repo.insert()
            |> elem(1)
        end)
      end)
  end
end
