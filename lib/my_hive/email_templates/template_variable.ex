defmodule MyHive.EmailTemplates.TemplateVariable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "email_templates_variables" do
    field :code, :string
    field :input_type, :string
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(template_variable, attrs) do
    template_variable
    |> cast(attrs, [:name, :code, :input_type, :description])
    |> validate_required([:name, :code, :input_type])
  end
end
