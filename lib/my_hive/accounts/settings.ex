defmodule MyHive.Accounts.Settings do
  import Ecto.Changeset
  use Ecto.Schema
  @derive {
    Jason.Encoder,
    only: [:document_provider_id,
      :default_file_sort_column, :default_file_sort_order,
      :default_color, :default_tab, :notifications]
  }
  embedded_schema do
    field :document_provider_id, :integer
    field :default_color, :string
    field :default_tab, :string, default: "current"
    field :default_file_sort_column, :string, default: "name"
    field :default_file_sort_order, :string, default: "asc"
    field :notifications, :boolean, default: true
    field :in_app_notifications, :boolean, default: true
    field :text_messages_notifications, :boolean, default: true
    field :email_notifications, :boolean, default: true
  end

  def default() do
    %MyHive.Accounts.Settings{
      document_provider_id: 1,
      default_color: "rgba(33, 150, 243, 0.75)",
      default_tab: "current",
      default_file_sort_column: "name",
      default_file_sort_order: "asc",
      notifications: true,
      in_app_notifications: true,
      text_messages_notifications: true,
      email_notifications: true
    }
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:document_provider_id, :text_messages_notifications,
      :email_notifications,:default_color, :default_tab])
  end
end
