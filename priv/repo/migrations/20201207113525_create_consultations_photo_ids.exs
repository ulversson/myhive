defmodule MyHive.Repo.Migrations.CreateConsultationsPhotoIds do
  use Ecto.Migration

  def change do
    create table(:consultations_photo_ids) do
      add :name, :string
      add :file_asset_id, :uuid
      add :patient_consultation_id, :integer
      timestamps()
    end

  end
end
