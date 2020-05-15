defmodule MyHive.Emails.SharingDirectoryEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  import MyHiveWeb.Router.Helpers
  def call(directory, email) do
    base_email()
    |> to(email)
    |> subject(topic(directory))
    |> assign(:user, directory.sharer)
    |> assign(:body, directory.note)
    |> assign(:sharing_link, sharing_link(directory))
    |> assign(:email, email)
    |> assign(:directory, directory)
    |> render("sharing_directory_email.html")
  end

  def deliver(directory, email) do
    call(directory, email) |> MyHive.Mailer.deliver_later
  end

  def sharing_link(directory) do
    shareable_url(MyHiveWeb.Endpoint, :verify, directory.token)
  end

  defp topic(directory) do
    "[myHive] User #{directory.sharer.first_name} #{directory.sharer.last_name} has shared some files with you on myHive"
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

end
