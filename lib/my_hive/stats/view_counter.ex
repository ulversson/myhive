defmodule MyHive.Stats.ViewCounter do
  use Ecto.Schema
  import Ecto.Changeset
  @foreign_key_type :binary_id
  schema "stats_view_counters" do
    field :countable_id, Ecto.UUID
    field :countable_type, :string
    field :viewed_by, :integer
    timestamps()
  end

  @doc false
  def changeset(view_counter, attrs) do
    view_counter
    |> cast(attrs, [:countable_id, :countable_type, :viewed_by])
    |> validate_required([:countable_id, :countable_type, :viewed_by])
  end
end
