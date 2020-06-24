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

  def update_time_entry(%TimeEntry{} = time_entry, attrs) do
    time_entry
    |> TimeEntry.changeset(attrs)
    |> Repo.update()
  end

  def del_time_entry(id) do
    id |> get_time_entry() |> Repo.delete()
  end

  def entries_by_ids(ids) do
    query = from te in TimeEntry,
      where: te.id in ^ids,
      preload: [{:medico_legal_case, :patient}],
      order_by: [:start_date, :end_date]
    Repo.all(query)
  end
end
