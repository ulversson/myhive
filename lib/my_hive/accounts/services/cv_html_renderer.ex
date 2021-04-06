defmodule MyHive.Accounts.Services.CvHtmlRenderer do

  import Phoenix.View
  import MyHive.Accounts.CVRendererCommon

  def call(fields) do
    render_to_string(MyHiveWeb.UserView,
      "cv_rendered.html",
        string_fields: filtered_fields(fields, "string", :pdf),
        text_fields: filtered_fields(fields, "text", :pdf),
        name: name_field(fields),
        position: position_field(fields)
      )
  end
  
  def name_field(fields) do
    Enum.filter(fields, fn ufield ->
      ufield.cv_field.name == "Name"
    end) |> List.first
  end

  def position_field(fields) do
    Enum.filter(fields, fn ufield ->
      ufield.cv_field.name == "Current position"
    end) |> List.first
  end

end
