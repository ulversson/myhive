
alias MyHive.{Repo, Reports}
alias MyHive.Reports.{
  ReportTemplate,
  ReportSection,
  ReportTemplateSection
}


sections = [
  %{
    name: "Opinion",
    letter: "O",
    is_letter_visible: true
  },%{
    name: "Letter",
    letter: "L",
    is_letter_visible: false
  }, %{
    name: "Medical History Summary",
    letter: "MHS",
    is_letter_visible: true
  },
  %{
    name: "Summary",
    letter: "S",
    is_letter_visible: true
  },
  %{
    name: "Opinion on Causation",
    letter: "C",
    is_letter_visible: true
  },
  %{
    name: "Opinion on Breach of Duty",
    letter: "B",
    is_letter_visible: true
  },
  %{
    name: "History",
    letter: "H",
    is_letter_visible: true
  }
]
Enum.each(sections, fn sec ->
  ReportSection.changeset(%ReportSection{}, sec)
    |> Repo.insert()
end)

reports = [
  %{
    name: "Letter Template",
    code: "lt",
    has_title_page: false,
    enabled: true
  },
  %{
    name: "Screening Medical Report",
    code: "screening_mr",
    has_title_page: true,
    enabled: false
  },
  %{
    name: "Medical Report on Breach of Duty",
    code: "mr_on_bod",
    has_title_page: true,
    enabled: false
  },
  %{
    name: "Medical Report on Causation and Breach of Duty",
    code: "mr_on_c_and_bod",
    has_title_page: true,
    enabled: false
  },
  %{
    name: "Medical Report on Causation",
    code: "mr_on_c",
    has_title_page: true,
    enabled: false
  },
  %{
    name: "Medical Report on current condition, giving opinions on causation and prognosis",
    code: "mr_on_cc_c_and_p",
    has_title_page: true,
    enabled: false
  },
  %{
    name: "Medical Report on current condition, giving an opinion on prognosis",
    code: "mr_on_cc_and_p",
    has_title_page: true,
    enabled: false
  }
]
Enum.each(reports, fn rep ->
  ReportTemplate.changeset(%ReportTemplate{}, rep)
    |> Repo.insert()
end)

report_sections = [
  %{
    report_template_id: Reports.find_template_by_code("lt").id,
    report_section_id: Reports.find_report_section_by_name("Letter").id
  },
  %{
    report_template_id: Reports.find_template_by_code("screening_mr").id,
    report_section_id: Reports.find_report_section_by_name("Medical History Summary").id
  },
  %{
    report_template_id: Reports.find_template_by_code("screening_mr").id,
    report_section_id: Reports.find_report_section_by_name("Opinion").id
  }
]

Enum.each(report_sections, fn rs ->
  ReportTemplateSection.changeset(%ReportTemplateSection{}, rs)
    |> Repo.insert()
end)
