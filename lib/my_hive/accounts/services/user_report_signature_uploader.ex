defmodule MyHive.Accounts.UserReportSignatureUploader do 

  alias MyHive.Repo
  alias MyHive.Accounts.{
    UserSignature,
    UserReportSignatureHoover
  }

  def call(files, user_id) when is_list(files) do 
    UserReportSignatureHoover.call(user_id)
    upload = files |> List.first()
    with {:ok, image} <- File.read(upload.path),
      content <- Base.encode64(image) do 
      %UserSignature{}
        |> UserSignature.changeset(%{
          image_content: content,
          content_type: upload.content_type,
          user_id: user_id
        }) 
        |> Repo.insert()
        |> elem(1)
     else
      _ -> false
     end
  end  

  def call(content, user_id) when is_binary(content) do 
    Repo.transaction(fn -> 
      UserReportSignatureHoover.call(user_id)
      %UserSignature{}
        |> UserSignature.changeset(%{
          image_content: content,
          content_type: "image/jpeg",
          user_id: user_id
        }) 
        |> Repo.insert()
        |> elem(1)
    end)
  end  

end  