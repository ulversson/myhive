defmodule MyHive.Accounts.Services.CvShareProcessor do

  alias MyHive.{Accounts, CVFields}
  alias MyHive.Shareable.Services.CvShareOutlookProcessor

  alias MyHive.Accounts.Services.CvPdfRenderer
  def call(emails, sender, user_cv_id) do
    expert = Accounts.get_user!(user_cv_id)
    pdf_path = user_cv_id
    |> Accounts.get_user!()
    |> CVFields.all_user_fields()
    |> CvPdfRenderer.call()
    |> elem(1)
    CvShareOutlookProcessor.call(emails, sender, expert, pdf_path)
  end

end
