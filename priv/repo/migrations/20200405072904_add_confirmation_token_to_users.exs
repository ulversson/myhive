defmodule MyHive.Repo.Migrations.AddConfirmationTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:confrimation_token, :string)
    end
  end
end
