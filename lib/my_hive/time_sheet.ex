defmodule MyHive.TimeSheet do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.TimeSheet.TimeEntry

  def create_time_entry(attrs \\ %{}) do
    %TimeEntry{}
    |> TimeEntry.changeset(attrs)
    |> Repo.insert()
  end

  def get_time_entry(id) do
    Repo.get_by(TimeEntry, id: id)
  end
end
