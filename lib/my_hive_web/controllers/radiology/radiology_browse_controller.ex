defmodule MyHiveWeb.Radiology.RadiologyBrowseController do
  use MyHiveWeb, :controller
  alias MyHive.Radiology
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}

  def index(conn, %{"patient" => patient}) do
    render(conn, "index.html", %{
      patient: patient
    })
  end
end
