defmodule MyHive.Saas.Logo do
  import Ecto.Changeset
  use Ecto.Schema

  alias MyHive.Saas.Services.LogoProcessor
  embedded_schema do
    field :path, :string, virtual: true
    field :width, :integer
    field :height, :integer
    field :base64, :string
    field :content_type, :string
    field :filename, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:path, :width, :height, :content_type, :filename])
    |> saveBase64()
    |> get_dimen()
  end

  def logo64(logo) when is_map(logo) do
    "data:#{logo.content_type};base64,#{logo.base64}"
  end

  def logo64(logo)  when is_nil(logo) do
    ""
  end

  def get_dimen(changeset) do
    path = get_change(changeset, :path)
    if is_nil(path) do
      changeset
    else
      image = LogoProcessor.call(path)
      put_change(changeset, :width, image.width)
      |> put_change(:height, image.height)
    end
  end

  defp saveBase64(changeset) do
    path = get_change(changeset, :path)
    if is_nil(path) do
      changeset
    else
      {:ok, image} = File.read(path)
      string = Base.encode64(image)
      put_change(changeset, :base64, string)
    end
  end
end
