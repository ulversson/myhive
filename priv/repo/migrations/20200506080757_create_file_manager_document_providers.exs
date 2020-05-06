defmodule MyHive.Repo.Migrations.CreateFileManagerDocumentProviders do
  use Ecto.Migration

  def change do
    create table(:file_manager_document_providers) do
      add :name, :string
      add :code, :string
      add :remote_url, :string

      timestamps()
    end

  end
end
