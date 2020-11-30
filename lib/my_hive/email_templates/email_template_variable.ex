defmodule MyHive.EmailTemplates.EmailTemplateVariable do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.EmailTemplates.{
    EmailTemplate, TemplateVariable
  }
  schema "email_template_template_variables" do
    belongs_to :template_variable, TemplateVariable
    belongs_to :email_template, EmailTemplate
  end

  @doc false
  def changeset(email_template_variable, attrs) do
    email_template_variable
    |> cast(attrs, [:email_template_id, :template_variable_id])
    |> validate_required([:email_template_id, :template_variable_id])
  end
end
