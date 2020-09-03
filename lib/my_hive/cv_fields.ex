defmodule MyHive.CVFields do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Accounts.{
    CVField, UserCVField
  }

  def create_field(%{} = changeset) do
    %CVField{}
      |> CVField.changeset(changeset)
      |> Repo.insert()
  end

  def create_user_cv_field(user, field) do
    %UserCVField{}
      |> UserCVField.changeset(%{order: field.order})
      |> Ecto.Changeset.put_assoc(:user, user)
      |> Ecto.Changeset.put_assoc(:cv_field, field)
      |> Repo.insert()
  end

  def all() do
    query = from cv_field in CVField,
    order_by: [:order]
    Repo.all(query)
  end

  def all_user_fields(user) do
    query = from cv_field in UserCVField,
    join: u in assoc(cv_field, :user),
    join: cvf in assoc(cv_field, :cv_field),
    preload: [:user, :cv_field],
    where: cv_field.user_id == ^user.id,
    order_by: [:order]
    Repo.all(query)
  end

  def set_value(user_cv_field, value) do
    user_cv_field
      |> UserCVField.changeset(%{field_value: value})
      |> Repo.update()
  end

  def get_user_field!(field_id) do
    Repo.get_by(UserCVField, id: field_id)
  end

end
