defmodule MyHive.ContactBook do
  @moduledoc """
  The ContactBook context.
  """

  import Ecto.Query, warn: false
  alias MyHive.Repo

  alias MyHive.ContactBook.Address

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    Repo.all(Address)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id)

  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{source: %Address{}}

  """
  def change_address(%Address{} = address) do
    Address.changeset(address, %{})
  end

  alias MyHive.ContactBook.CasePerson

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people()
      [%CasePerson{}, ...]

  """
  def list_people do
    Repo.all(CasePerson)
  end

  @doc """
  Gets a single case_person.

  Raises `Ecto.NoResultsError` if the Case person does not exist.

  ## Examples

      iex> get_case_person!(123)
      %CasePerson{}

      iex> get_case_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_case_person!(id), do: Repo.get!(CasePerson, id)

  @doc """
  Creates a case_person.

  ## Examples

      iex> create_case_person(%{field: value})
      {:ok, %CasePerson{}}

      iex> create_case_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_case_person(attrs \\ %{}) do
    %CasePerson{}
    |> CasePerson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a case_person.

  ## Examples

      iex> update_case_person(case_person, %{field: new_value})
      {:ok, %CasePerson{}}

      iex> update_case_person(case_person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_case_person(%CasePerson{} = case_person, attrs) do
    case_person
    |> CasePerson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a case_person.

  ## Examples

      iex> delete_case_person(case_person)
      {:ok, %CasePerson{}}

      iex> delete_case_person(case_person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_case_person(%CasePerson{} = case_person) do
    Repo.delete(case_person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking case_person changes.

  ## Examples

      iex> change_case_person(case_person)
      %Ecto.Changeset{source: %CasePerson{}}

  """
  def change_case_person(%CasePerson{} = case_person) do
    CasePerson.changeset(case_person, %{})
  end
end
