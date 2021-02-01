defmodule MyHive.Reports do

  @report_page_size 10
  
  import Ecto.Query, warn: false
  alias MyHive.Reports.{
    ReportTemplate,
    ReportSection,
    ReportSectionContent,
    UserMedicoLegalCaseReport
  }
  alias MyHive.{Repo}

  def create_report_template(attrs) do
    %ReportTemplate{}
      |> ReportTemplate.changeset(attrs)
      |> Repo.insert()
  end

  def list_templates(q, is_enabled) when is_binary(q) and q != "" do
    query = from t in ReportTemplate,
      where: t.enabled == ^is_enabled,
      where: ilike(t.name, ^"%#{q}%"),
      preload: [:sections, :report_sections],
      order_by: [{:asc, :name}]
    Repo.all(query)
  end

  def list_templates(q, is_enabled) when is_nil(q) or q == "" do
    query = from t in ReportTemplate,
      where: t.enabled == ^is_enabled,
      preload: [:sections, :report_sections],
      order_by: [{:asc, :name}]
    Repo.all(query)
  end

  def find_template_by_code(code) do
    query = from t in ReportTemplate,
      where: t.code == ^code
    Repo.one(query)
  end

  def find_report_section_by_name(name) do
    query = from s in ReportSection,
      where: s.name == ^name
    Repo.one(query)
  end

  def find_section_by_id(id) do
    Repo.get_by!(ReportSection, id: id)
  end

  def by_id(id) do
    q = from ur in UserMedicoLegalCaseReport,
      preload: [
        :report_section_contents,
        {:report_template, :report_sections},
        {:user, :user_signature},
        :folder,
        :medico_legal_case
      ],
      where: ur.id == ^id
    Repo.one(q)
  end

  defp reports_for_user_query(user_id) do
    from ur in UserMedicoLegalCaseReport,
      where: ur.user_id == ^user_id,
      preload: [
        :report_section_contents,
        :report_template,
        :user,
        :folder,
        :medico_legal_case
      ]
  end

  def by_user(user_id) do
    user_id
      |> reports_for_user_query()
      |> Repo.all()
  end

  def by_user_for_case(page, user_id, mlc_id) do
    user_id
      |> reports_for_user_query()
      |> order_by([r], {:desc, :id})
      |> where([ur], ur.medico_legal_case_id == ^mlc_id)
      |> Repo.paginate(page: page, page_size: @report_page_size)
  end

  def reports_for_case(page, mlc_id) do 
    query = from umlcr in UserMedicoLegalCaseReport,
      where: umlcr.medico_legal_case_id == ^mlc_id,
       preload: [
        :report_section_contents,
        :report_template,
        :user,
        :folder,
        :medico_legal_case
      ]
    query 
      |> order_by([r], {:desc, :id})
      |> Repo.paginate(page: page, page_size: @report_page_size)
  end

  def update_content(report_section_content, params) do 
    report_section_content
      |> ReportSectionContent.changeset(params)
      |> Repo.update()
      |> elem(1)
  end

  def update_document(report, asset_id, folder_id) do 
    UserMedicoLegalCaseReport.changeset(report, %{
      file_asset_id: asset_id,
      folder_id: folder_id
    })
    |> Repo.update()
    |> elem(1)
  end

  def update_report(report, params) do
    UserMedicoLegalCaseReport.changeset(report, params)
    |> Repo.update()
    |> elem(1)
  end

end
