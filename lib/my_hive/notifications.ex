defmodule MyHive.Notifications do

  import Ecto.Query, warn: false
  import MyHive.CaseManagement.MedicoLegalCaseNotificationData
  alias MyHive.Repo
  alias MyHive.Notifications.Notification

  def get_notification!(id), do: Repo.get!(Notification, id)

  def create_for_case(recipient, medico_legal_case) do
    mlc_case_data = case_data(medico_legal_case)
    require IEx
    IEx.pry
    {:ok, notification} =
    %Notification{}
      |> Notification.changeset(
          Map.merge(mlc_case_data, %{
          recipient_id: recipient.id,
          sender_id: medico_legal_case.user_id
        }))
      |> Repo.insert()
    notification
  end

  def unread_for_user(user_id) do
    query = from n in Notification,
      where: n.recipient_id == ^user_id and n.viewed == false
    query
      |> order_by([n], desc: n.id)
      |> Repo.all
  end

  def view(notification) do
    notification
    |> Notification.changeset(%{viewed: true})
    |> Repo.update()
  end

end
