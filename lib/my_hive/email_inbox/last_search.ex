defmodule MyHive.EmailInbox.LastSearch do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.CaseManagement.MedicoLegalCase
  alias MyHive.Oauth2.Provider
  alias MyHive.Accounts.User

  schema "email_inbox_last_searches" do
    field :last_searched_at, :naive_datetime
    belongs_to :medico_legal_case, MedicoLegalCase
    belongs_to :provider, Provider
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(last_search, attrs) do
    last_search
    |> cast(attrs, [:provider_id, :medico_legal_case_id, :user_id, :last_searched_at])
    |> validate_required([:provider_id, :medico_legal_case_id, :user_id, :last_searched_at])
  end
end
