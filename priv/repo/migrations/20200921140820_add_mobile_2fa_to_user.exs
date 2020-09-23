defmodule MyHive.Repo.Migrations.AddMobile2faToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :mobile_2fa, :string
    end
  end
end
