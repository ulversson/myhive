defmodule MyHive.Supervisors.FileSharingSupervisor do
  def share_file(user_id, directory, email) do
    opts = [restart: :transient]

    Task.Supervisor.start_child(
      __MODULE__,
       MyHive.Shareable.SharingDirectoryProcessor,
      :upload_to_correspondence,
      [directory, email], opts
    )
    Task.Supervisor.start_child(
      __MODULE__,
      MyHive.Shareable.SharedOutlookEmailProcessor,
      :call,
      [user_id, directory, email], opts
    )
  end
end
