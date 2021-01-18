alias MyHive.CaseManagement.MedicoLegalCaseProgressState
alias MyHive.{Repo, CaseManagement}

Enum.each(CaseManagement.all_ordered_stages(), fn stage ->
  icon = case stage.name do
    "Medical report produced" -> "fal fa-laptop-medical"
    "Letter of Claim reviewed" -> "fal fa-envelope-open-text"
    "Medical report finalised" -> "fal fa-files-medical"
    "Letter of Response reviewed" -> "fal fa-reply"
    "Counsel’s Conference" -> "fal fa-users"
    "Particulars of Claim reviewed" -> "fal fa-list-ol"
    "Defence reviewed" -> "fal fa-shield"
    "Witness Summons received" ->  "fal fa-gavel"
    "Joint Meeting of Experts" -> "fal fa-user-md-chat"
    "Joint report produced" -> "fal fa-user-md-chat"
    "Settlement" -> "fal fa-handshake"
  end
  MedicoLegalCaseProgressState.changeset(stage, %{
    icon: icon
  }) |> Repo.update()
end)
