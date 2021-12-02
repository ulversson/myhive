const modalities = {
  CR: {name: "Computed Radiography", color: "#E0BBE4"},
  CT: {name: "Computed Tomography", color: "#E0787C"},
  MR: {name: "Magnetic Resonance", color: "#D291BC"},
  NM: {name: "Nuclear Medicine", color: "#FEC8D8"},
  US: {name: "Ultrasound", color: "#FFDFD3"},
  OT: {name: "Other", color: "#D2F3DC"},
  BI: {name: "Biomagnetic imaging", color: "#E5F9E1"},
  DG: {name: "Diaphanography", color: "#FFF9D7"},
  ES: {name: "Endoscopy", color: "#D8F2FB"},
  LS: {name: "Laser surface scan", color: "#A4A9A7"},
  PT: {name: "Positron emission tomography (PET)", color: "#BADBCA"},
  RG: {name: "Radiographic imaging (conventional film/screen)", color: "#FDEBCE"},
  TG: {name: "Thermography", color: "#F3D7B2"},
  XA: {name: "X-Ray Angiography", color: "#EFC1BA"},
  RF: {name: "Radio Fluoroscopy", color: "#B8D1E5"},
  RTIMAGE: {name: "Radiotherapy Image", color: "#EAF1F4"},
  RTDOSE: {name: "Radiotherapy Dose", color: "#FAFAF7"},
  RTSTRUCT: {name: "Radiotherapy Structure Set", color: "#CAABD5"},
  RTPLAN: {name: "Radiotherapy Plan", color: "#E1CEC9"},
  RTRECORD: {name: "RT Treatment Record", color: "#EBE6E5"},
  HC: {name: "Hard Copy", color: "#DFD8DC"},
  DX: {name: "Digital Radiography", color: "#D2C1CE"},
  MG: {name: "Mammography", color: "#B4BAD4"},
  IO: {name: "Intra-oral Radiography", color: "#D4CFBD"},
  PX: {name: "Panoramic X-Ray", color: "#C8E0FD"},
  GM: {name: "General Microscopy", color: "#DBEBFF"},
  SM: {name: "Slide Microscopy", color: "#FFF0F9"},
  XC: {name: "External-camera Photography", color: "#FFDDF4"},
  PR: {name:"Presentation State", color: "#FFCCE7"},
  AU: {name: "Audio", color: "#FFF5CC"},
  ECG: {name: "Electrocardiography", color: "#D8EBDB"},
  EPS: {name: "Cardiac Electrophysiology", color: "#A8C1C6"},
  HD: {name: "Hemodynamic Waveform", color: "#B9E2EB"},
  SR: {name: "SR Document", color: "#DBC970"},
  IVUS: {name: "Intravascular Ultrasound", color: "#DCD5C3"},
  OP: {name: "Ophthalmic Photography", color: "#E4E6E1"},
  SMR: {name: "Stereometric Relationship", color: "#B1D3E3"},
  AR: {name: "Autorefraction", color: "#FAEED9"},
  KER: {name: "Keratometry", color: "#FFFFEB"},
  VA: {name: "Visual Acuity", color: "#FCE8F8"},
  SRF: {name: "Subjective Refraction", color: "#EAD1F0"},
  OCT: {name: "Optical Coherence Tomography (non-Ophthalmic)", color: "#DBD7D3"},
  LEN: {name: "Lensometry", color: "#F6F1F1"},
  OPV: {name: "Ophthalmic Visual Field", color: "#CECAD3"},
  OPM: {name: "Ophthalmic Mapping", color: "#F2EEE5"},
  OAM: {name: "Ophthalmic Axial Measurements", color: "#CFDBEE"},
  RESP: {name: "Respiratory Waveform", color: "#DCEDE6"},
  KO: {name: "Key Object Selection", color: "#C5DBF7"},
  SEG: {name: "Segmentation", color: "#FAE3F6"},
  REG: {name: "Registration", color: "#FFF5FD"},
  OPT: {name: "Ophthalmic Tomography", color: "#F7EBDF"},
  BDUS: {name: "Bone Densitometry (ultrasound)", color: "#D5D5F9"},
  BMD: {name: "Bone Densitometry (X-Ray)",color: "#E0ECCB"},
  DOC: {name: "Document", color: "#D39CB6"},
  FID: {name: "Fiducials", color: "#FFADBB"},
  PLAN: {name: "Plan", color: "#F6D5C2"},
  IOL: {name: "Intraocular Lens Data", color: "#FFF3DE"},
  IVOCT: {name: "Intravascular Optical Coherence Tomography", color: "#C6DFC8"}
}

export default modalities