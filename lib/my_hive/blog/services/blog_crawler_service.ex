defmodule MyHive.Blog.Services.BlogCrawlerService do

  def call(url) do
    {str, 0} = System.cmd("bundle", ["exec", "ruby", path_to_rubyfile(), url])
    result = String.split(str, "\n")
    %{
      image: Enum.at(result, 0),
      title: Enum.at(result, 1),
      description: Enum.at(result, 2)
    }
  end

  def image_download(url) do
    :inets.start()
    :ssl.start()
    filename = Path.basename(url)
    output_path = String.to_charlist(Path.join("/tmp", Path.basename(url)))
    {:ok, :saved_to_file} = :httpc.request(:get,
      {String.to_charlist(url), []},
      [], [stream: output_path]
    )
    output_path |> to_string()
  end

  def url_to_base64(url) do
    path = image_download(url)
    {:ok, data} = path |> File.read()
    "data:#{MIME.from_path(path)};base64,#{Base.encode64(data, padding: false)}"
  end

  defp path_to_rubyfile(file \\ "thumbnailer.rb") do
    Path.join([File.cwd!, "lib", "my_hive", "blog", "services", file])
  end

end
