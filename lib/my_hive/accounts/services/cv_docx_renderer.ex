defmodule MyHive.Accounts.Services.CvDocxRenderer do

  import MyHive.Accounts.CVRendererCommon
  @release_dir "_build/prod/rel/my_hive"

  def call(fields, output_file) do
    output_path = Path.dirname(output_file)
    unless File.exists?(output_path) do
      File.mkdir_p(output_path)
    end
    convert_command(fields, output_file)
  end

  defp name_field(fields) do
    Enum.filter(fields, fn ufield ->
      ufield.cv_field.name == "Name"
    end) |> List.first
  end

  defp fields_map(fields, type) do
    fields
      |> filtered_fields(type, :docx)
      |> Enum.map(fn field -> %{
          name: field.cv_field.name,
          value: field.field_value
        }
      end)
      |> Jason.encode!
  end

  defp convert_command(fields, output_file) do
    System.cmd("node", [
      convert_script(),
      output_file,
      name_field(fields).field_value,
      fields_map(fields, "string"),
      fields_map(fields, "text")
    ])
  end

  defp convert_script() do
    if env() == :dev do
      Path.join([File.cwd!, "assets", "js", "wordgen.js"])
    else
      String.replace(File.cwd!, @release_dir, "assets/js/wordgen.js")
    end
  end

  defp env do
    Application.get_env(:my_hive, :environment)
  end

end
