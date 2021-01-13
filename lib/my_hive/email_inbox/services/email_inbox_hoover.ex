defmodule MyHive.EmailInbox.Services.EmailInboxHoover do

  alias MyHive.IncomingMessages

  def call(ids) when is_binary(ids) do
    ids
    |> String.split(",")
    |> Enum.each(fn email_id ->
      IncomingMessages.delete_email(email_id)
    end)
  end

  def call(ids) when is_binary(ids) === false do
  end

end
