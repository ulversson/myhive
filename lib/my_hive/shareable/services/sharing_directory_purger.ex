defmodule MyHiveWeb.Plugs.SharingDirectoryPurger do
  alias MyHive.{
    Repo, Shareable
  }

  def call() do
    Shareable.get_old_shared_directories()
      |> Repo.delete_all()
  end
end
