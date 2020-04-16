defmodule MyHive.CaseManagement do
  @moduledoc """
  The CaseManagement context.
  """

  import Ecto.Query, warn: false
  alias MyHive.Repo

  alias MyHive.CaseManagement.MedicoLegalCase

  @doc """
  Returns the list of medico_legal_cases.

  ## Examples

      iex> list_medico_legal_cases()
      [%MedicoLegalCase{}, ...]

  """
  def list_medico_legal_cases do
    Repo.all(MedicoLegalCase)
  end

  @doc """
  Gets a single medico_legal_case.

  Raises `Ecto.NoResultsError` if the Medico legal case does not exist.

  ## Examples

      iex> get_medico_legal_case!(123)
      %MedicoLegalCase{}

      iex> get_medico_legal_case!(456)
      ** (Ecto.NoResultsError)

  """
  def get_medico_legal_case!(id), do: Repo.get!(MedicoLegalCase, id)

  @doc """
  Creates a medico_legal_case.

  ## Examples

      iex> create_medico_legal_case(%{field: value})
      {:ok, %MedicoLegalCase{}}

      iex> create_medico_legal_case(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medico_legal_case(attrs \\ %{}) do
    %MedicoLegalCase{}
    |> MedicoLegalCase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a medico_legal_case.

  ## Examples

      iex> update_medico_legal_case(medico_legal_case, %{field: new_value})
      {:ok, %MedicoLegalCase{}}

      iex> update_medico_legal_case(medico_legal_case, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_medico_legal_case(%MedicoLegalCase{} = medico_legal_case, attrs) do
    medico_legal_case
    |> MedicoLegalCase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a medico_legal_case.

  ## Examples

      iex> delete_medico_legal_case(medico_legal_case)
      {:ok, %MedicoLegalCase{}}

      iex> delete_medico_legal_case(medico_legal_case)
      {:error, %Ecto.Changeset{}}

  """
  def delete_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    Repo.delete(medico_legal_case)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking medico_legal_case changes.

  ## Examples

      iex> change_medico_legal_case(medico_legal_case)
      %Ecto.Changeset{source: %MedicoLegalCase{}}

  """
  def change_medico_legal_case(%MedicoLegalCase{} = medico_legal_case) do
    MedicoLegalCase.changeset(medico_legal_case, %{})
  end
end
