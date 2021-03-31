defmodule MyHive.Reports.UserReportProcessor do

  import MyHive.Reports.ReportAssetCommon
  alias MyHive.Repo
  alias MyHive.Reports.{
    ReportSectionsCreator,
    UserMedicoLegalCaseReport,
    ReportGlossaryOfTerm
  }

  def call(%{"report_template_sections" => sections} = params, draft, unique_key \\ nil) do
    case create_report(params, draft, unique_key) do 
      {:ok, report} -> 
        ReportSectionsCreator.call(sections, report.id, params["user_id"])
        report = Repo.preload(report, [
          :report_section_contents,
          :report_template,
          :user,
          :folder,
          {:report_glossary_of_terms, :glossary_of_term},
          :medico_legal_case
        ])
        save_tags(report, params["taggable_ids"])
        save_report_in_file_manager(report)
      {:error, changeset} -> 
        false
      end
  end

  defp save_tags(report, tags) when is_map(tags) do 
    Enum.each(Map.values(tags), fn tag -> 
      %ReportGlossaryOfTerm{}
        |> ReportGlossaryOfTerm.changeset(%{
          user_medico_legal_case_report_id: report.id,
          glossary_of_term_id: tag["id"],
          content: tag["content"]
        }) |> Repo.insert()
    end)
  end

  defp save_tags(_report, tags) when is_nil(tags) do
  end

  def create_report(params, draft, unique_key) do 
    res = %UserMedicoLegalCaseReport{}
      |> UserMedicoLegalCaseReport
          .changeset(Map.merge(params, %{"unique_key" => unique_key, "draft" => draft}))
      |> Repo.insert()
  end

end
