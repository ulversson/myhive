defmodule MyHive.Reports do

  @report_page_size 10
  
  import Ecto.Query, warn: false
  alias MyHive.Reports.{
    ReportTemplate,
    ReportSection,
    ReportSectionContent,
    UserMedicoLegalCaseReport,
    GlossaryOfTerm
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
        {:report_section_contents, :report_template_section},
        {:report_template, :report_sections},
        {:user, :user_signature},
        :folder,
        {:medico_legal_case, [:patient, :instructing_party]},
        {:report_glossary_of_terms, :glossary_of_term}
      ],
      join: c in assoc(ur, :report_section_contents),
      join: rts in assoc(c, :report_template_section),
      order_by: [{:asc, rts.order}, {:asc, c.occurred_on}],
      where: ur.id == ^id,
      where: is_nil(ur.unique_key),
      where: ur.id == c.user_report_id,
      group_by: [ur.id, c.occurred_on, rts.order],
      limit: 1
    Repo.one(q)
  end

  defp reports_for_user_query(user_id, drafts \\ false) do
    query = from ur in UserMedicoLegalCaseReport,
      where: ur.user_id == ^user_id,
      join: c in assoc(ur, :report_section_contents),
      distinct: ur.id,
      preload: [
        :report_section_contents,
        {:report_template, :report_sections},
        :user,
        :folder,
        {:report_glossary_of_terms, :glossary_of_term},
        {:medico_legal_case, :patient}
    ]
    if drafts do 
      query 
        |> where([r], is_nil(r.unique_key) == false)
    else
      query 
        |> where([r], is_nil(r.unique_key))
    end  
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
      join: c in assoc(umlcr, :report_section_contents),
      distinct: umlcr.id,
       preload: [
        :report_section_contents,
        {:report_template, :report_sections},
        :user,
        :folder,
        {:report_glossary_of_terms, :glossary_of_term},
        {:medico_legal_case, :patient}
      ],
      where: umlcr.medico_legal_case_id == ^mlc_id, 
      where: is_nil(umlcr.unique_key)
    query 
      |> order_by([r, c], {:asc, c.order})
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

  def create_glossary_item(glossary_item) do 
    %GlossaryOfTerm{}
      |> GlossaryOfTerm.changeset(glossary_item)
      |> Repo.insert()
  end

  defp glossary_items_for_letter_query(letter) do
    from g in GlossaryOfTerm,
      where: g.letter == ^letter,
      order_by: [{:asc, :name}] 
  end

  def glossary_items_for_letter(letter) do 
    query = glossary_items_for_letter_query(letter)
    Repo.all(query)
  end

  def glossary_items_like(like) do
    keyword = "%#{like}%"
    query = from g in GlossaryOfTerm,
      where: ilike(g.name, ^keyword) or
        ilike(g.short_name, ^keyword),
      order_by: [{:asc, :name}] 
    Repo.all(query)  
  end

  def update_glossay_of_term_field(got, field, value) do
    got
      |> GlossaryOfTerm.changeset(%{field => value})
      |> Repo.update()
  end

  def got_by_id(id) do
    Repo.get_by(GlossaryOfTerm, id: id)
  end

  def delete_got_item(got_item) do
    got_item |> Repo.delete()
  end

  def last_draft(user_id, mlc_id, template_id) do
    result = user_id
      |> reports_for_user_query(true)
      |> order_by([r], {:desc, :id})
      |> where([ur], ur.medico_legal_case_id == ^mlc_id)
      |> where([ur], ur.report_template_id == ^template_id)
      |> Repo.all()
    if length(result) > 0 do
      result |> tl |> List.last   
    else
      false
    end  
  end

  def count_headers_for_report(report_id, header) do 
    query = from rsc in ReportSectionContent,
      where: rsc.user_report_id == ^report_id,
      where: rsc.header == ^header
    Repo.aggregate(query, :count, :id)
  end

end
