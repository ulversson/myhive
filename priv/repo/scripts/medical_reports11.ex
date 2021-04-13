alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplate, 
}

toc = "ABBREVIATED CV|Glossary of terms|Summary|Introduction & Document List|Summary|Medical History|Opinion on Breach of Duty|DECLARATION OF RESPONSIBLITIES|Literature"

rt = Reports.find_template_by_code("mr_on_bod")

rt |> ReportTemplate.changeset(%{toc_string: toc})   |> Repo.update()


