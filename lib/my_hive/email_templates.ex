defmodule MyHive.EmailTemplates do

  import Ecto.Query, warn: false
  alias MyHive.EmailTemplates.{
    TemplateVariable,
    EmailTemplate,
    EmailTemplateVariable
  }
  alias MyHive.Repo

  def create_email_variable(changeset) do
    %TemplateVariable{}
      |> TemplateVariable.changeset(changeset)
      |> Repo.insert()
  end

  def create_email_template(changeset) do
    %EmailTemplate{}
      |> EmailTemplate.changeset(changeset)
      |> Repo.insert()
  end

  def create_template(changeset) do
    %EmailTemplate{}
    |> EmailTemplate.ui_create_changeset(changeset)
    |> Repo.insert()
  end

  def get_variable_by_code(variable_code) do
    Repo.get_by(TemplateVariable, code: variable_code)
  end

  def get_by_name(name) do
    Repo.get_by(EmailTemplate, name: name)
  end

  def get_by_id(id) do
    Repo.get_by(EmailTemplate, id: id)
  end

  def get_with_vars(id) do
    id
      |> get_by_id()
      |> Repo.preload(:template_variables)
  end

  def get_by_name_with_variables(name) do
    name
      |> get_by_name()
      |> Repo.preload(:template_variables)
  end

  def create_join_table_var(template_id, variable_id) do
    %EmailTemplateVariable{}
      |> EmailTemplateVariable.changeset(%{
        email_template_id: template_id,
        template_variable_id: variable_id
      })
      |> Repo.insert()
  end

  def ordered_all() do
    query = from t in EmailTemplate,
    order_by: [{:asc, :name}]
    Repo.all(query)
  end

  def all_variables() do
    query = from t in TemplateVariable,
    order_by: [{:asc, :name}]
    Repo.all(query)
  end

  def update_email_template(template, changeset) do
    template
      |> EmailTemplate.changeset(changeset)
      |> Repo.update()
  end

  def existing_vars(var_list) do
    from(t in TemplateVariable,
      where: t.code in ^var_list)
    |> Repo.all()
  end

  def delete_template(template_id) do
    email_template = template_id |> get_by_id()
    query = from etv in EmailTemplateVariable,
      where: etv.email_template_id == ^template_id
    Repo.transaction(fn ->
      Repo.delete(email_template)
      Repo.delete_all(query)
    end)
  end

end
