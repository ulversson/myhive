defmodule MyHive.CVFields do

  import Ecto.Query, warn: false
  alias MyHive.Repo
  alias MyHive.Accounts.{
    CVField,
    UserCVField,
    User,
    CVBundle
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

  def fields_for_user_query(user) do
    from cv_field in UserCVField,
      join: u in assoc(cv_field, :user),
      join: cvf in assoc(cv_field, :cv_field),
      where: cv_field.user_id == ^user.id,
      preload: [:user, :cv_field],
      order_by: [:order]
  end

  defp fields_for_user_delete_query(user) do
    from cv_field in UserCVField,
      join: u in assoc(cv_field, :user),
      join: cvf in assoc(cv_field, :cv_field),
      where: cv_field.user_id == ^user.id
  end

  def all_user_fields(user) do
    query = fields_for_user_query(user)
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

  def create_user_fields(user) do
    Enum.each(all(), fn field ->
      create_user_cv_field(user, field)
    end)
  end

  def remove_fields_for_user(user) do
    user
      |> fields_for_user_delete_query
      |> Repo.delete_all()
  end

  def users_with_fields(more_than_count) do
    query = from u in User,
      preload: [:user_cv_fields, :cv_fields]
    users = Repo.all(query)
    Enum.filter(users, fn u ->
      length(Enum.filter(u.user_cv_fields, fn ucvf ->
        is_nil(ucvf.field_value) == false and ucvf.field_value != ""
      end)) >= more_than_count
    end)
  end

  def create_bundle(%{} = changeset) do
    %CVBundle{}
      |> CVBundle.changeset(changeset)
      |> Repo.insert()
  end

  def last_bundle() do
    Repo.one(from x in CVBundle, order_by: [desc: x.id], limit: 1)
  end

  def remove_all_bundles() do
    Repo.delete_all(CVBundle)
  end

end
