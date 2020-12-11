defmodule MyHive.Supervisors.PdfOptimizerSupervisor do
  def call(file_asset, content_type) do
    opts = [restart: :transient]

    Task.Supervisor.start_child(
      __MODULE__,
      MyHive.FileManager.Services.PdfSizeOptimizer,
      :call,
      [file_asset, content_type], opts
    )
  end
end
