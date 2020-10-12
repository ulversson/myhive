defmodule MyHive.Accounts.Services.CvHtmlHeaderRenderer do

  import Phoenix.View

  def render_header(name, position) do
    render_to_string(MyHiveWeb.UserView,
      "cv_header.html",
        name: name,
        position: position
      )
  end

end
