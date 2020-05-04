defmodule MyHive.Stats do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Stats.{ViewCounter}

  def add_view_count(attrs \\ %{}) do
    %ViewCounter{}
    |> ViewCounter.changeset(attrs)
    |> Repo.insert()
  end


end
