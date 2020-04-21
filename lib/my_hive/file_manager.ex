defmodule MyHive.FileManager do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.FileManager.Folder
  alias MyHive.TreeManager
require IEx

  def create_folders_from_tree(map, user_id, parent_id \\ nil) do
    Enum.each(map, fn({folder, subfolder}) ->
      {:ok, f} = create_folder(%{ name: folder, folder_type: "medico_legal_case",
        parent_id: parent_id, user_id: user_id
      })

      if is_list(subfolder) do
        Enum.each(subfolder, fn subfolder_name ->
          TreeManager.create_child(subfolder_name, f.id, user_id, "medico_legal_case")
        end)
      end
      if is_map(subfolder) do
        create_folders_from_tree(subfolder, user_id, f.id)
      end
    end)
  end
  def get_folder!(id), do: Repo.get!(Folder, id)
  def create_folder(attrs \\ %{}) do
    %Folder{}
    |> Folder.changeset(attrs)
    |> Repo.insert()
  end
end
