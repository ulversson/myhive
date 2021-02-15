defmodule MyHive.Radiology do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Radiology.RadiologyImport
  alias MyHive.FileManager.FileServer

  def radiology_import_from(file_asset, medico_legal_case_id) do
    changes = %{
      name: file_asset.name,
      description: file_asset.caption,
      path: FileServer.call(file_asset) <> ".zip",
      medico_legal_case_id: medico_legal_case_id
    }
    %RadiologyImport{}
      |> RadiologyImport.changeset(changes)
      |> Repo.insert()
  end

  def radiology_import_with_error(file_asset, medico_legal_case_id, error) do
    changes = %{
      name: file_asset.name,
      description: file_asset.caption,
      path: FileServer.call(file_asset) <> ".zip",
      error: error,
      medico_legal_case_id: medico_legal_case_id
    }
    %RadiologyImport{}
      |> RadiologyImport.changeset(changes)
      |> Repo.insert()
  end

  def update_result(radiology_import, result) do
    radiology_import
      |> RadiologyImport.changeset(%{result: result})
      |> Repo.update()
  end

  def update_name(radiology_import, name) do
    radiology_import
      |> RadiologyImport.changeset(%{name: name})
      |> Repo.update()
      |> elem(1)
  end

  def imports_for_case(medico_legal_case_id) do
    query = from ri in RadiologyImport,
      where: ri.medico_legal_case_id == ^medico_legal_case_id
    imports = query
      |> order_by([ri], asc: ri.name)
      |> Repo.all()
    Repo.preload(imports,
      [{:medico_legal_case, :patient}]
    )
  end

  def get_radiology_import!(id) do
    Repo.get!(RadiologyImport, id)
  end

  def delete_import(import_id) do
    import_id |> get_radiology_import!() |> Repo.delete()
  end
end
