defmodule MyHive.Accounts.Settings do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field :document_provider_id, :integer
    field :default_color, :string
  end


  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:document_provider_id, :default_color])
  end
end
