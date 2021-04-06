defmodule MyHive.ImageUtils do

  import Mogrify

  def resize(file_path, max_height, :height, overwrite) when overwrite == true do
    open(file_path) |> resize("x#{max_height}")  |> save(in_place: true)
  end
  
  def resize(file_path, max_height, :height, overwrite) when overwrite == false do
    open(file_path) |> resize("x#{max_height}")  |> save
  end
  
  def resize(file_path, max_width, :width, overwrite) when overwrite == true do
    open(file_path) |> resize("#{max_width}x")  |> save(in_place: true)
  end
  
  def resize(file_path, max_width, :width, overwrite) when overwrite == false do
    open(file_path) |> resize("#{max_width}x")  |> save
  end  
  
end