defmodule MyHive.Shareable.SharedEmailPdfRenderer do
  import MyHiveWeb.Router.Helpers
  alias MyHive.Shareable

  def call(dir, email) do
    dir = Shareable.preload_all(dir)
    dir |> to_html(email, true) |> PdfGenerator.generate(page_size: "A4")
  end

  def to_html(dir, email, true) do
    Phoenix.View.render_to_string(MyHiveWeb.EmailView,
      "sharing_directory_email.html",
        conn: %Plug.Conn{},
        user: dir.sharer,
        body: dir.note,
        subject: topic(dir),
        show_send_details: true,
        sharing_link: sharing_link(dir, email),
        email: email,
        directory: dir
      )
  end

  def to_html(dir, email, false) do
    Phoenix.View.render_to_string(MyHiveWeb.EmailView,
      "sharing_directory_email2.html",
        conn: %Plug.Conn{},
        user: dir.sharer,
        layout: {MyHiveWeb.LayoutView, "email.html"},
        body: dir.note,
        subject: topic(dir),
        show_send_details: false,
        sharing_link: sharing_link(dir, email),
        email: email,
        directory: dir
      )
  end

  defp sharing_link(directory, email) do
    shareable_url(MyHiveWeb.Endpoint, :verify, directory.token) <> "?email=#{email}"
  end

  def topic(directory) do
    "[my-hive] Ref: #{directory.medico_legal_case.file_reference} - #{directory.saas_account.name} is disclosing files with you."
  end

end
