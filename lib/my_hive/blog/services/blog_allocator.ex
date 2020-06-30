defmodule MyHive.Blog.Services.BlogAllocator do
  alias MyHive.Blog
  alias MyHive.Blog.Services.{
    BlogWarehouseman,
    BlogImageThumbnailer
  }
  def call(plug_files, user_id) do
    db_files = Enum.map(plug_files, fn file ->
      file_map = BlogWarehouseman.call(file.path, file.filename)
      file_data = Map.from_struct(file)
        |> Map.merge(file_map)
        |> Map.merge(%{user_id: user_id})
      {:ok, att} = Blog.create_attachment(file_data)
      if (att.content_type =~ "image") do
        BlogImageThumbnailer.call(att)
      end
      att
    end)
    db_files
  end

end
