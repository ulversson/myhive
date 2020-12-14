defmodule MyHive.EmailTemplates.Services.OutlookPdfRenderer do

  alias MyHive.{
    Repo, EmailTemplates
  }

  def call(email_from_template) do
    email = email_from_template
    |> Repo.preload([:email_template, :medico_legal_case])
    email.email_body
      |> PdfGenerator.generate(page_size: "A4")
      |> elem(1)
  end

end
