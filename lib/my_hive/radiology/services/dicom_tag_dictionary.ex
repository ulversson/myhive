defmodule MyHive.Radiology.Services.DicomTagDictionary do
  alias MyHive.JsonLoader
  
  def all_tags() do
    JsonLoader.json_content("dicom.json")
  end
  
  def all_tags_as_tuples() do
    all_tags |> Enum.map( fn({key, value}) -> {key, value} end)
  end
  
  def tag_name(tag_value) do
    all_tags()[tag_value]
  end
end