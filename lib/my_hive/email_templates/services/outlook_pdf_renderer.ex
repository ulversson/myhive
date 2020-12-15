defmodule MyHive.EmailTemplates.Services.OutlookPdfRenderer do

  alias MyHive.Repo

  def call(email_from_template) do
    email = email_from_template
    |> Repo.preload([:email_template, :medico_legal_case])
    html_template(email.email_body, email)
      |> PdfGenerator.generate(page_size: "A4")
      |> elem(1)
  end

  defp html_template(html_body, email) do
    """
    <!DOCTYPE html>
    <html>
      <head>
      <link rel="preconnect" href="https://fonts.gstatic.com">
      <link href="https://fonts.googleapis.com/css2?family=Roboto:300,400,600" rel="stylesheet">
      <meta charset="UTF-8">
      <style>body {font-size: 16.5px !important; font-family: "Roboto", sans-serif; font-weight: 400 !important;}</style>
      <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
      </head>
      <body>
        <table style="margin-bottom: 75px">
          <tr>
            <td style="font-weight: 700 !important"><strong>From:</strong></td>
            <td>#{email.from_email_address}</td>
          </tr>
          <tr>
            <td style="font-weight: 700 !important"><strong>To:</strong></td>
            <td>#{email.recipients}</td>
          </tr>
          <tr>
            <td style="font-weight: 700 !important"><strong>Sent:</strong></td>
            <td>#{email.inserted_at |> Timex.format!("%d/%m/%Y %H:%M", :strftime)}</td>
          </tr>
        </table>
        #{html_body}
      </body>
    </html>
    """
  end

end
