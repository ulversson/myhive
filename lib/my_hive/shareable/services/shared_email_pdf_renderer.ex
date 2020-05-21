defmodule MyHive.Shareable.SharedEmailPdfRenderer do
  import MyHiveWeb.Router.Helpers
  alias MyHive.Shareable

  def call(dir, email) do
    dir = Shareable.preload_all(dir)
    dir |> to_html(email) |> PdfGenerator.generate(page_size: "A4")
  end

  defp sharing_link(directory, email) do
    shareable_url(MyHiveWeb.Endpoint, :verify, directory.token) <> "?email=#{email}"
  end

  defp topic(directory) do
    "[myHive] Ref: #{directory.medico_legal_case.file_reference} - #{directory.saas_account.name} is disclosing files to you."
  end

  defp to_html(dir, email) do
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

end
