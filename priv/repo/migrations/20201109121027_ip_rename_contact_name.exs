defmodule MyHive.Repo.Migrations.IpRenameContactName do
  use Ecto.Migration

  def change do
    rename table(:instructing_parties), :contact_name, to: :reference
  end
end
