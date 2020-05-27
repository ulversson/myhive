defmodule MyHive.Supervisors.RadiologySupervisor do
  def call(file_asset, filetype, file_map) do
    opts = [restart: :transient]

    Task.Supervisor.start_child(
      __MODULE__,
      MyHive.Radiology.RadiologyImporter,
      :call,
      [file_asset, filetype, file_map], opts
    )
  end
end
