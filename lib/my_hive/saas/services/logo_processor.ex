defmodule MyHive.Saas.Services.LogoProcessor do
  import Mogrify
  @width "360"
  @height "240"

  def call(path) do
    open(path)
      |> resize("#{@width}x#{@height}")
      |> save(in_place: true)
    open(path) |> verbose
  end

  def width() do
    @width
  end

  def height() do
    @height
  end
end
