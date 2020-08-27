defmodule MyHive.Accounts.CvGenerator do
  alias MyHive.FileManager.FileAssetAllocator
  alias MyHive.Accounts.CV
  alias MyHive.{Repo, Accounts}

  def call(user_id) do
    Repo.transaction(fn ->
      user = user_id  |> Accounts.get_user!()
      filename = "#{user.first_name} #{user.last_name}'s CV.docx"
      cv_data = FileAssetAllocator.call(CV.template_path, filename, false)
      attrs = Map.merge(cv_data, %{user_id: user_id, name: filename})
      Accounts.create_cv(attrs)
    end)
  end
end
