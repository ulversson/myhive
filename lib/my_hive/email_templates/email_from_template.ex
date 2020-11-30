defmodule MyHive.EmailTemplates.EmailFromTemplate do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.EmailTemplates.EmailTemplate

  schema "sent_emails" do
    field :bcc_recipients, :string
    field :email_body, :string
    field :from_email_address, :string
    field :recipients, :string
    belongs_to :from_user, User
    belongs_to :email_template,EmailTemplate
    timestamps()
  end

  @doc false
  def changeset(email_from_template, attrs) do
    email_from_template
    |> cast(attrs, [:email_template_id, :email_body, :from_user_id, :from_email_address, :recipients, :bcc_recipients])
    |> validate_required([:email_template_id, :email_body, :from_user_id, :from_email_address, :recipients, :bcc_recipients])
  end
end
