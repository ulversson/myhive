defmodule MyHive.Repo.Migrations.ChangeAddresses do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      remove(:address_line1)
      remove(:address_line2)
      remove(:address_line3)
      add(:address, :text)
    end
  end
end
