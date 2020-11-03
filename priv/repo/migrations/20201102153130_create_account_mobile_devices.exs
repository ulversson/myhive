defmodule MyHive.Repo.Migrations.CreateAccountMobileDevices do
  use Ecto.Migration

  def change do
    create table(:account_mobile_devices) do
      add :os, :string
      add :token, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
