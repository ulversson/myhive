defmodule MyHiveWeb.Api.V1.Shareables.ShareableView do
  use MyHiveWeb, :view

  def render("directories.json", %{dirs: dirs}) do
    Enum.map(dirs, &dir_json/1)
  end

  def dir_json(dir) do
    %{
      id: dir.id,
      viewed: dir.approved,
      email: dir.emails,
      first_name: dir.first_name,
      last_name: dir.last_name,
      count: length(dir.file_assets),
      expires: dir.expires
    }
  end
end
