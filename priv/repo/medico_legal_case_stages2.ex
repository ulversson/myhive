alias MyHive.CaseManagement.MedicoLegalCaseProgressState
alias MyHive.Repo

Repo.delete_all(MedicoLegalCaseProgressState)

stages = [
  %{
    name: "Medical report produced",
    order: 1,
    icon: "fas fa-signature",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Medical report finalised",
    order: 2,
    icon: "fas fa-file-contract",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Letter of Claim reviewed",
    order: 3,
    icon: "fas fa-envelope-open-text",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Letter of Response reviewed",
    order: 4,
    icon: "fas fa-reply-all",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Counsel’s Conference",
    order: 5,
    icon: "fas fa-comments",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Particulars of Claim reviewed",
    order: 6,
    icon: "fas fa-info-circle",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Defence reviewed",
    order: 7,
    icon: "fas fa-shield-alt",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Witness Summons received",
    order: 8,
    icon: "fas fa-users",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Joint Meeting of Experts",
    order: 9,
    icon: "fas fa-user-clock",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Joint report produced",
    order: 10,
    icon: "fas fa-scroll",
    partial_percentage: 9.09,
    is_default: true
  },
  %{
    name: "Settlement",
    order: 11,
    icon: "fas fa-handshake",
    partial_percentage: 9.09,
    is_default: true
  }
]

Enum.each(stages, fn stage_map ->
 changeset =  MedicoLegalCaseProgressState
  .changeset(%MedicoLegalCaseProgressState{}, stage_map)
 Repo.insert(changeset)
end)
