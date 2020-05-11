defmodule MyHive.Accounts.Settings do
  import Ecto.Changeset
  use Ecto.Schema
  @derive {
    Jason.Encoder,
    only: [:document_provider_id, :default_color, :default_tab, :notifications, :new_items]
  }
  embedded_schema do
    field :document_provider_id, :integer
    field :default_color, :string
    field :default_tab, :string, default: "current"
    field :notifications, :boolean, default: true
    field :new_items, :boolean, default: false
  end


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:document_provider_id, :default_color, :default_tab])
  end
end
