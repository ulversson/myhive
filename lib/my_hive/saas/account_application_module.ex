defmodule MyHive.Saas.AccountApplicationModule do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Saas.{
    Account, ApplicationModule
  }

  schema "saas_account_application_modules" do
    field :activated_at, :naive_datetime
    field :deactivated_at, :naive_datetime
    belongs_to :account, Account, foreign_key: :saas_account_id
    belongs_to :application_module, ApplicationModule
    timestamps()
  end

  @doc false
  def changeset(account_application_module, attrs) do
    account_application_module
    |> cast(attrs, [:application_module_id, :saas_account_id, :activated_at, :deactivated_at])
    |> validate_required([:application_module_id, :saas_account_id, :activated_at])
  end
end
