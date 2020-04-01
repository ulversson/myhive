defmodule MyHive.Repo.Migrations.AddAvatarSvgToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:avatar_svg, :text)
    end
  end
end
