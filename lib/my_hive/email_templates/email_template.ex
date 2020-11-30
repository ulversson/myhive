defmodule MyHive.EmailTemplates.EmailTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.EmailTemplates.{
    EmailTemplateVariable
  }
  schema "email_templates" do
    field :body, :string
    field :include_case_reference, :boolean, default: false
    field :name, :string
    field :description, :string
    field :subject, :string
    has_many :email_template_variables, EmailTemplateVariable
    has_many :template_variables, through: [:email_template_variables, :template_variable]
    timestamps()
  end

  @doc false
  def changeset(email_template, attrs) do
    email_template
    |> cast(attrs, [:name, :body, :subject, :include_case_reference, :description])
    |> validate_required([:name, :body, :subject])
  end
end
