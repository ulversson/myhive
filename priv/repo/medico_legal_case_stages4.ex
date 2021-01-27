alias MyHive.CaseManagement.MedicoLegalCaseProgressState
alias MyHive.{Repo, CaseManagement}

Enum.each(CaseManagement.all_ordered_stages(), fn stage ->
  name = case stage.icon do
    "fal fa-laptop-medical" -> "Medical Report Produced"
    "fal fa-envelope-open-text" -> "Letter of Claim Reviewed"
    "fal fa-files-medical" -> "Medical Report Finalised"
    "fal fa-reply" -> "Letter of Response Reviewed"
    "fal fa-users" -> "Counsel’s Conference"
    "fal fa-list-ol" -> "Particulars of Claim Reviewed"
    "fal fa-shield" -> "Defence Reviewed"
    "fal fa-gavel" -> "Witness Summons Received"
    "fal fa-user-md-chat" -> "Joint Meeting of Experts"
    "fal fa-user-md-chat" -> "Joint Report Produced"
    "fal fa-handshake" -> "Settlement"
  end

  MedicoLegalCaseProgressState.changeset(stage, %{
    name: name
  }) |> Repo.update()

end)
#update medico_legal_case_progress_stages set name='Joint Report Produced'  where id=29;
# update medico_legal_case_progress_stages set  icon='fal fa-file-medical' where id=21;
# update medico_legal_case_progress_stages set  icon='fal fa-file-medical' where id=21;
