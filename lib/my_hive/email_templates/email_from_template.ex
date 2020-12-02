defmodule MyHive.EmailTemplates.EmailFromTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.EmailTemplates.{
    EmailTemplate, VariableJson
  }

  schema "sent_emails" do
    field :bcc_recipients, :string
    field :email_body, :string
    field :from_email_address, :string
    field :recipients, :string
    embeds_one :variables, VariableJson, on_replace: :delete
    belongs_to :from_user, User
    belongs_to :email_template, EmailTemplate
    timestamps()
  end

  @doc false
  def changeset(email_from_template, attrs) do
    email_from_template
    |> cast(attrs, [:email_template_id, :email_body, :from_user_id, :from_email_address, :recipients, :bcc_recipients])
    |> cast_embed(:variables)
    |> validate_required([:email_template_id, :email_body, :from_user_id, :from_email_address, :recipients])
  end

  def variables_merge(sent_email) do
    merged_variables = Enum.reduce(Map.values(sent_email["variables"]), fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
    end)
    Map.put(sent_email, "variables", merged_variables)
  end

end
