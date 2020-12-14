defmodule MyHive.EmailTemplates.EmailTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.EmailTemplates.{
    EmailTemplateVariable, TemplateVariable
  }
  alias MyHive.EmailTemplates
  schema "email_templates" do
    field :body, :string
    field :name, :string
    field :variables_list, :string, virtual: true
    has_many :email_template_variables, EmailTemplateVariable
    many_to_many :template_variables, TemplateVariable, join_through: "email_template_template_variables"
    timestamps()
  end

  def ui_create_changeset(email_template, attrs) do
    email_template
    |> cast(attrs, [:name, :body, :variables_list])
    |> validate_required([:name, :body])
    |> process_variables()
  end

  @doc false
  def changeset(email_template, attrs) do
    email_template
    |> cast(attrs, [:name, :body])
    |> validate_required([:name, :body])
  end

  def process_variables(changeset) do
    var_list = changeset.changes
      |> Map.get(:variables_list, "")
      |> String.split(",")
      |> Enum.map(&(String.trim(&1)))
      |> Enum.reject(fn(name) -> name == "" end)
      |> Enum.map(&(String.downcase(&1)))
      |> Enum.uniq
      |> Enum.sort
    existing_vars = EmailTemplates.existing_vars(var_list)
    vars = Enum.map(var_list, fn(code) ->
      new_var = struct(TemplateVariable, code: code)
      Enum.find(existing_vars, new_var, fn(existing_var) ->
        existing_var.code == code
      end)
    end)
    var_changeset = Enum.map(vars, &Ecto.Changeset.change/1)
    changeset |> Ecto.Changeset.put_assoc(:template_variables, var_changeset)
  end
end
