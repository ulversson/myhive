defmodule MyHive.Saas.ApplicationModule do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Saas

  schema "saas_application_modules" do
    field :description, :string
    field :icon, :string
    field :monthly_price, :decimal
    field :name, :string
    field :sidebar, :boolean, default: true
    field :admin_only, :boolean, default: false
    field :short_name, :string
    timestamps()
  end

  @doc false
  def changeset(application_module, attrs) do
    application_module
    |> cast(attrs, [:name, :description, :sidebar, :admin_only, :icon, :short_name, :monthly_price])
    |> validate_required([:name, :description, :icon, :monthly_price])
  end

  def active_for_account?(account_id, module_id) do
    active_modules = Saas.app_modules_ids_for_account(account_id)
    Enum.member?(active_modules, module_id)
  end
end
