defmodule MyHive.Accounts.QuickLink do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Regex.RegularExpressions

  schema "account_quick_links" do
    field :link_url, :string
    field :name, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(quick_link, attrs) do
    quick_link
    |> cast(attrs, [:link_url, :name, :user_id])
    |> validate_required([:link_url, :name, :user_id])
    |> append_protocol_to_url()
  end

  defp append_protocol_to_url(changeset) do
    url = get_change(changeset, :link_url)
    if url do
      if String.match?(url, RegularExpressions.http_https()) do
        changeset
      else
        put_change(changeset, :link_url, "https://#{url}")
      end
    else
      changeset
    end
  end
end
