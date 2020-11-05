defmodule MyHive.Repo.Migrations.AddUdidToMobileDevices do
  use Ecto.Migration

  def change do
    alter table(:account_mobile_devices) do
      add :udid, :string
    end
  end
end
