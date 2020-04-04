defmodule MyHive.Repo.Migrations.AddMoreAvatarSizes do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:avatar_128, :text)
      add(:avatar_256, :text)
    end
    rename table(:users), :avatar_svg, to: :avatar_32
  end
end
