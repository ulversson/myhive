defmodule MyHive.Repo.Migrations.AddSessionFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:force_sign_out, :boolean, default: false)
    end
  end
end
