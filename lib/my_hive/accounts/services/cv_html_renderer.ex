defmodule MyHive.Accounts.Services.CvHtmlRenderer do

  import Phoenix.View
  import MyHive.Accounts.CVRendererCommon

  def call(fields) do
    render_to_string(MyHiveWeb.UserView,
      "cv_rendered.html",
        string_fields: filtered_fields(fields, "string", :pdf),
        text_fields: filtered_fields(fields, "text", :pdf)
      )
  end

end
