defmodule MyHive.Emails.SharingDirectoryEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  import MyHiveWeb.Router.Helpers
  def call(directory, email) do
    base_email()
    |> to(email)
    |> subject(topic(directory))
    |> assign(:user, directory.sharer)
    |> assign(:body, directory.note)
    |> assign(:sharing_link, sharing_link(directory, email))
    |> assign(:email, email)
    |> assign(:subject, topic(directory))
    |> assign(:directory, directory)
    |> assign(:show_send_details, false)
    |> render("sharing_directory_email.html")
  end

  def deliver(directory, email) do
    call(directory, email) |> MyHive.Mailer.deliver_later
  end

  def sharing_link(directory, email) do
    shareable_url(MyHiveWeb.Endpoint, :verify, directory.token) <> "?email=#{email}"
  end

  defp topic(directory) do
    "[my-hive] Ref: #{directory.medico_legal_case.file_reference} - #{directory.saas_account.name} is disclosing files to you."
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

end
