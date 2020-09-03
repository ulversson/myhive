defmodule MyHive.Repo.Migrations.RemoveUserCvs do
  use Ecto.Migration

  def change do
    drop table("accounts_cvs")
  end
end
