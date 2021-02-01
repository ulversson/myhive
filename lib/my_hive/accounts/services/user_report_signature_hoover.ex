defmodule MyHive.Accounts.UserReportSignatureHoover do 

  alias MyHive.Repo
  alias MyHive.Accounts.UserSignature

  import Ecto.Query, warn: false

  def call(user_id) do 
    query = from us in UserSignature, 
      where: us.user_id == ^user_id
    Repo.delete_all(query)
  end

end