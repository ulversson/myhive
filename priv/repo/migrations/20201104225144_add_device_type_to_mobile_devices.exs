defmodule MyHive.Repo.Migrations.AddDeviceTypeToMobileDevices do
  use Ecto.Migration

  def change do
    alter table(:account_mobile_devices) do
      add :device_type, :string
    end
  end
end
