defmodule MyHive.Accounts.CVFieldUpdater do
  alias MyHive.CVFields
  alias MyHive.Repo

  def call(fields) do
    Repo.transaction(fn ->
      Enum.each(fields, fn {field_id, value} ->
        field = CVFields.get_user_field!(field_id)
        CVFields.set_value(field, value)
      end)
    end)
  end
end
