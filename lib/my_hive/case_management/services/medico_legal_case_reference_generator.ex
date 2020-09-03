defmodule MyHive.CaseManagement.MedicoLegalCaseReferenceGenerator do

  alias MyHive.Repo
  alias MyHive.CaseManagement
  def call(medico_legal_case, false) do
    medico_legal_case = Repo.preload(medico_legal_case, [:patient, :user, :users])
    String.upcase("#{Timex.today.year}/#{expert_user_initials(medico_legal_case)}/#{medico_legal_case.patient.last_name}/#{creator_initials(medico_legal_case)}")
  end

  def call(medico_legal_case, true) do
    ref = call(medico_legal_case, false)
    CaseManagement.update_case(medico_legal_case, %{
      file_reference: ref
    })
  end

  defp expert_user(users) do
    experts = Enum.filter(users,
      fn user -> Enum.member?(user.roles, "expert") end) |> List.first
      if (is_nil(experts)) do
        List.first(users)
      else
        experts
      end
  end

  defp expert_user_initials(medico_legal_case) do
    expert = medico_legal_case.users |> expert_user()
    "#{String.first(expert.first_name)}#{String.first(expert.last_name)}"
  end

  defp creator_initials(medico_legal_case) do
    creator = medico_legal_case.user
    "#{String.first(creator.first_name)}#{String.first(creator.last_name)}"
  end
end
