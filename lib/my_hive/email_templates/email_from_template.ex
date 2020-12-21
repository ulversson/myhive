defmodule MyHive.EmailTemplates.EmailFromTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.FileManager.Folder
  alias MyHive.EmailTemplates.{
    EmailTemplate, VariableJson
  }
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.Repo
  schema "sent_emails" do
    field :bcc_recipients, :string
    field :email_body, :string
    field :from_email_address, :string
    field :recipients, :string
    field :folder_id, Ecto.UUID
    embeds_one :variables, VariableJson, on_replace: :delete
    belongs_to :from_user, User
    belongs_to :email_template, EmailTemplate
    belongs_to :medico_legal_case, MedicoLegalCase
    timestamps()
  end

  @doc false
  def changeset(email_from_template, attrs) do
    email_from_template
    |> cast(attrs, [:email_template_id, :email_body, :from_user_id, :folder_id, :from_email_address,
      :recipients, :bcc_recipients, :medico_legal_case_id])
    |> cast_embed(:variables)
    |> validate_required([:email_template_id, :email_body, :folder_id, :from_user_id, :from_email_address, :recipients])
  end

  def variables_merge(sent_email) do
    merged_variables = Enum.reduce(Map.values(sent_email["variables"]), fn x, y ->
      Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
    end)
    Map.put(sent_email, "variables", merged_variables)
  end

  def processed_subject(email) do
    email =  Repo.preload(email, [:email_template,  [medico_legal_case: :instructing_party]])
    reference = if is_nil(email.medico_legal_case.instructing_party) , do: "no data", else:  email.medico_legal_case.instructing_party.reference
    "Ref: #{String.upcase(email.medico_legal_case.file_reference)}, ID: #{email.medico_legal_case_id}, Your ref: #{reference}"
  end

end
