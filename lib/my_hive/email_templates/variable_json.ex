defmodule MyHive.EmailTemplates.VariableJson do
  use Ecto.Schema

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
end
