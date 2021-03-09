defmodule MyHive.Accounts.CVRendererCommon do

  def filtered_fields(fields, type, :pdf) do
    fields |> Enum.filter(fn ufield ->
      ufield.cv_field.field_type == type
        and ufield.field_value != nil
        and ufield.field_value != ""
        and ufield.cv_field.name != "Name"
        and ufield.cv_field.name != "Current position"
    end)
  end

  def filtered_fields(fields, type, :docx) do
    fields |> Enum.filter(fn ufield ->
      ufield.cv_field.field_type == type
        and ufield.field_value != nil
        and ufield.field_value != ""
        and ufield.cv_field.name != "Name"
    end)
  end

   def filtered_fields(fields, type, :non_blank) do
    fields |> Enum.filter(fn ufield ->
      ufield.cv_field.field_type == type
        and ufield.field_value != nil
        and ufield.field_value != ""
    end)
  end

end
