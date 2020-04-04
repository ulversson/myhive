defmodule MyHive.Repo.Migrations.GuardianTrackable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :sign_in_count, :integer, default: 0
      add :last_sign_in_ip, :string
      add :last_sign_in_at, :utc_datetime
      add :current_sign_in_ip, :string
      add :current_sign_in_at, :utc_datetime
    end
  end
end