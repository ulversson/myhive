defmodule MyHive.EmailTemplates.VariableJson do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:date, :naive_datetime)
    field(:expert_name, :string)
    field(:recipient_name, :string)
    field(:court_name, :string)
    field(:expert_discipline, :string)
    field(:free_text, :string)
    field(:hourly_rate, :string)
    field(:free_text_one_line, :string)
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:date, :expert_name, :free_text,
        :hourly_rate, :free_text_one_line, :recipient_name,:court_name,
        :expert_discipline
      ])
  end
end
