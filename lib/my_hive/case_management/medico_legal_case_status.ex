defmodule MyHive.CaseManagement.MedicoLegalCaseStatus do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyHive.CaseManagement.{
    MedicoLegalCase,
    MedicoLegalCaseProgressState
  }
  alias MyHive.Accounts.User
  alias MyHive.CaseManagement

  schema "medico_legal_case_statuses" do
    field :completed_at, :naive_datetime
    field :order, :integer
    field :name, :string
    field :started_at, :naive_datetime
    belongs_to :medico_legal_case, MedicoLegalCase
    belongs_to :medico_legal_case_progress_state, MedicoLegalCaseProgressState
    belongs_to :user, User, foreign_key: :completed_by
    belongs_to :starter, User, foreign_key: :started_by
    timestamps()
  end

  @doc false
  def changeset(medico_legal_case_status, attrs) do
    medico_legal_case_status
    |> cast(attrs, [:medico_legal_case_id, :name, :medico_legal_case_progress_state_id, :started_at, :completed_at, :completed_by, :started_by, :order])
    |> validate_required([:medico_legal_case_id, :name, :medico_legal_case_progress_state_id, :order])
  end

  def next_status(mlc_status, user_id) do
    cond do
      is_nil(mlc_status.started_at) && is_nil(mlc_status.completed_at)
        -> CaseManagement.update_medico_legal_case_status(mlc_status, %{
          started_by: user_id,
          started_at: Timex.now
        })
      !is_nil(mlc_status.started_at) && is_nil(mlc_status.completed_at)
        -> CaseManagement.update_medico_legal_case_status(mlc_status, %{
          completed_by: user_id,
          completed_at: Timex.now
        })
      !is_nil(mlc_status.started_at) && !is_nil(mlc_status.completed_at)
        -> CaseManagement.update_medico_legal_case_status(mlc_status, %{
            completed_by: nil, completed_at: nil, started_at: nil, started_by: nil
          })
    end
  end
end
