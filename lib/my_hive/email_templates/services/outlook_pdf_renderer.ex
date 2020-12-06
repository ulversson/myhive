defmodule MyHive.EmailTemplates.Services.OutlookPdfRenderer do

  alias MyHive.{
    Repo, EmailTemplates
  }

  def call(email_from_template) do
    email = email_from_template
    |> Repo.preload([:email_template, :medico_legal_case])
    signature = EmailTemplates.user_signature(email.from_user_id)
    email_body(email, signature)
      |> PdfGenerator.generate(page_size: "A4")
      |> elem(1)
  end

  def email_body(email, signature) do
    "#{email.email_body}#{signature.content}"
  end

end
