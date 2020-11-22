defmodule MyHive.ZipCommon do

  def create_files_list(path) do
    create_files_list(File.ls!(path), path)
  end

  def create_files_list(paths, path) do
    create_files_list(paths, path, path)
  end

  def create_files_list(paths, path, base_path) do
    Enum.reduce(paths, [],
      fn(filename, acc) ->
        filename_path = Path.join(path, filename)
        if File.dir?(filename_path) do
          acc ++ create_files_list(File.ls!(filename_path), filename_path, base_path)
        else
          filenm =
            if base_path,
              do: String.replace_leading(filename_path, base_path, ""),
              else: filename_path
          [{String.to_charlist(filenm), File.read!(filename_path)} | acc]
        end
      end
    )
  end

  def zip_file_path(storage) do
    "#{storage}.zip"
  end

end
