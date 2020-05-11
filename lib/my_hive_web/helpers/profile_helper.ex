defmodule MyHiveWeb.Helpers.ProfileHelper do
  alias MyHive.FileManager.DocumentProvider
  alias MyHive.Repo
  import Phoenix.HTML.Form
  def providers_for_select(document_provider_id) do
    providers = Repo.all(DocumentProvider)
      |> Enum.map(&{"#{&1.name}}", &1.id})
    providers ++ [document_provider_id]
  end
end
