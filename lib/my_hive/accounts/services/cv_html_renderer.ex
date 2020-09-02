defmodule MyHive.Accounts.Services.CvHtmlRenderer do

  import Phoenix.View

  def call(fields) do
    render_to_string(MyHiveWeb.UserView,
      "cv_rendered.html",
        string_fields: filtered_fields(fields, "string"),
        text_fields: filtered_fields(fields, "text")
      )
  end

  defp filtered_fields(fields, type) do
    fields |> Enum.filter(fn ufield ->
      ufield.cv_field.field_type == type
        and ufield.field_value != nil
        and ufield.field_value != ""
        and ufield.cv_field.name != "Name"
    end)
  end

end
