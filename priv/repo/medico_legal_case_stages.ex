alias MyHive.CaseManagement.MedicoLegalCaseProgressState
alias MyHive.Repo
stages = [
  %{
    name: "Draft report produced",
    order: 1,
    icon: "fas fa-signature",
    partial_percentage: 12.5
  },
  %{
    name: "Report finalised",
    order: 2,
    icon: "fas fa-file-contract",
    partial_percentage: 12.5
  },
  %{
    name: "Letter of Claim reviewed",
    order: 3,
    icon: "fas fa-envelope-open-text",
    partial_percentage: 12.5
  },
  %{
    name: "Letter of Response reviewed",
    order: 4,
    icon: "fas fa-reply-all",
    partial_percentage: 12.5
  },
  %{
    name: "Particulars of Claim reviewed",
    order: 5,
    icon: "fas fa-info-circle",
    partial_percentage: 12.5
  },
  %{
    name: "Defence reviewed",
    order: 6,
    icon: "fas fa-shield-alt",
    partial_percentage: 12.5
  },
  %{
    name: "Witness Summons received",
    order: 7,
    icon: "fas fa-users",
    partial_percentage: 12.5
  },
  %{
    name: "Case settled",
    order: 8,
    icon: "fas fa-handshake",
    partial_percentage: 12.5
  }
]

Enum.each(stages, fn stage_map ->
 changeset =  MedicoLegalCaseProgressState
  .changeset(%MedicoLegalCaseProgressState{}, stage_map)
 Repo.insert(changeset)
end)
