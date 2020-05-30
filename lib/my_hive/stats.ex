defmodule MyHive.Stats do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Stats.{ViewCounter}

  def add_view_count(attrs \\ %{}) do
    %ViewCounter{}
    |> ViewCounter.changeset(attrs)
    |> Repo.insert()
  end

  def for_user(query, user_id) do
    query |> where([i], i.viewed_by == ^user_id)
  end

  def for_asset(query, asset_id) do
  query |> where([i], i.countable_id == ^asset_id
    and i.countable_type == "FileAsset")
  end

  def view_counts(user_id, asset_id) do
    view_counts_query(user_id, asset_id)
      |> Repo.one
  end

  def view_counts_query(user_id, asset_id) do
    query = from vc in ViewCounter, select: count(vc.id)
    query
      |> for_user(user_id)
      |> for_asset(asset_id)
  end

  def first_or_create(attrs \\ %{}) do
    view_counts = view_counts_query(attrs.viewed_by, attrs.countable_id)
    result =
    case Repo.one(view_counts) do
      0 ->
        {:ok, new} = add_view_count(attrs)
        new
      found ->
        found
    end
    result
  end

end
