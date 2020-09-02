defmodule MyHive.Accounts.CVRendererCommon do

  def filtered_fields(fields, type) do
    fields |> Enum.filter(fn ufield ->
      ufield.cv_field.field_type == type
        and ufield.field_value != nil
        and ufield.field_value != ""
        and ufield.cv_field.name != "Name"
    end)
  end

end
