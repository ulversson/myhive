defmodule MyHive.WalkDirectory do

  def find(dir \\ ".", search \\ "DICOMDIR") do
    Enum.map(File.ls!(dir), fn file ->
      fname = "#{dir}/#{file}"
      if File.dir?(fname) do
        find(fname, search)
      else
        fname
      end
    end)
     |> List.flatten
     |> Enum.filter(fn i -> i =~ search end)
  end

  def exists?(path, filename) do
    length(find(path, filename))  > 0
  end

end
