
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportSection,
  ReportTemplateSection
}

sections = [
  %{
    name: "Declaration",
    letter: "D",
    is_letter_visible: false
  }
]
Enum.each(sections, fn sec ->
  ReportSection.changeset(%ReportSection{}, sec)
    |> Repo.insert()
end)

report = Reports.find_template_by_code("mr_on_bod")
  |> Repo.preload(:report_sections)

report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("mr_on_bod").id,
    report_section_id: Reports.find_report_section_by_name("Declaration").id,
    is_taggable: false,
    default_content: List.to_string('<div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I understand that my overriding duty is to the Court, both in preparing reports and in giving oral evidence and I have complied with this duty.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I confirm that I am aware of the requirements of Part 35 and Practice Direction 35 of the Civil Procedure Rules.&nbsp;I confirm that I am aware of the requirements of the Guidance for the Instruction of Experts to give Evidence in Civil Claims.&nbsp;I confirm that I am also aware of the requirements of Part 19 and Practice Directions Division V Evidence, in particular 19A, 19B and 19C of the Criminal Procedure Rules.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I have set out in my report what I understand from those instructing me to be the questions in respect of which my opinion as an expert is required.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I have done my best, in preparing this report, to be accurate and complete.&nbsp;I have mentioned all matters which I regard as relevant to the opinions I have expressed.&nbsp;All of the matters on which I have expressed an opinion lie within my field of expertise.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I confirm that I have made clear which facts and matters referred to in this report are within my own knowledge and which are not.&nbsp;Those that are within my own knowledge I confirm to be true.&nbsp;The opinions I have expressed represent my true and complete professional opinions on the matters to which they refer.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I have drawn to the attention of the Court all matters of which I am aware might adversely affect my opinion.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">Wherever I have no personal knowledge, I have indicated the source of factual information.</span></div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I have not included anything in this report which has been suggested to me by anyone, including lawyers instructing me, without forming an independent view of the matter.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">Where, in my view, there is a range of reasonable opinion, I have indicated the extent of that range in the report.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">At the time of signing the report I consider it to be complete and accurate.&nbsp;I will notify those instructing me if, for any reason, I subsequently consider that the report requires any correction or qualification. </span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I understand this report will be the evidence I will give under oath, subject to any correction or qualification I may make before swearing to its veracity.</span></div><div class="ql-align-justify">&nbsp;</div><div class="ql-align-justify"><span style="color: rgb(0, 0, 0);">I believe the facts I have stated in this report are true and that the opinions I have expressed are correct. I understand that proceedings for contempt of court may be brought against anyone who makes, or causes to be made, a false statement in a document verified by a statement of truth without an honest belief in its truth</span></div>'),
    has_timestamp: false,
    order: 5
  }
]

Enum.each(report_sections, fn rs ->
  require IEx; IEx.pry;
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs)
    |> Repo.insert()
end)
