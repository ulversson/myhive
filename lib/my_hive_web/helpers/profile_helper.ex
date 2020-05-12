defmodule MyHiveWeb.Helpers.ProfileHelper do
  alias MyHive.FileManager.DocumentProvider
  alias MyHive.Repo

  def providers_for_select() do
    Repo.all(DocumentProvider) |> Enum.map(&{"#{&1.name}}", &1.id})
  end
end
