// _certificateInailDto è l 'oggetto che dovrebbe arrivare a jasperFrom:
Paolo
Russian_certificateInailDto.per* -> primo tab ("dati personali")
Russian_certificateInailDto.cer* -> secondo tab ("certificato")
Russian_certificateInailDto.evt* -> terzo tab ("evento")
Russian_certificateInailDto.emp* -> quarto tab ("datore di lavoro")


var buildCertificateInailDto = function() {
  var _certificateInailDto = {};
  _certificateInailDto.id = $scope.certData.id;
  _certificateInailDto.encounterId = $scope.certData.encounterId;
  _certificateInailDto.doctor = {};
  _certificateInailDto.statusCode = $scope.certData.status;
  _certificateInailDto.lastextraction = $scope.certData.lastextraction;
  _certificateInailDto.extracted = $scope.certData.extracted;
  _certificateInailDto.perLastName = $scope.certData.personal.lastName;
  _certificateInailDto.perFirstName = $scope.certData.personal.firstName;
  _certificateInailDto.perUniqueIdentifier = $scope.certData.personal.uniqueIdentifier;
  _certificateInailDto.perBirthDate = $scope.certData.personal.birthDate;
  _certificateInailDto.perGender = $scope.certData.personal.gender.id;
  _certificateInailDto.perBirthPlace = {};
  _certificateInailDto.perBirthPlace = $scope.certData.personal.birthPlace;
  _certificateInailDto.perNationality = $scope.certData.personal.nationality;
  _certificateInailDto.perIstat = $scope.certData.personal.istat;
  if ($scope.certData.personal.absent) _certificateInailDto.perAbsent = $scope.certData.personal.absent.id;
  _certificateInailDto.perTel1Acode = $scope.certData.personal.phone_areaCode;
  _certificateInailDto.perTel1Number = $scope.certData.personal.phone;
  _certificateInailDto.perTel2Acode = $scope.certData.personal.mobilePhone_areaCode;
  _certificateInailDto.perTel2Number = $scope.certData.personal.mobilePhone;
  _certificateInailDto.perBirthProv = $scope.certData.personal.birthProvince;
  if ($scope.certData.personal.home) {
    if ($scope.certData.personal.home) {
      if ($scope.certData.personal.home.residenzaEstera) _certificateInailDto.perHForeign = $scope.certData.personal.home.residenzaEstera.id;
      _certificateInailDto.perHAddress = $scope.certData.personal.home.address;
      _certificateInailDto.perHAddressNumber = $scope.certData.personal.home.addressNumber;
      _certificateInailDto.perHAddressZip = $scope.certData.personal.home.zipCode;
      _certificateInailDto.perHMunicipality = $scope.certData.personal.home.municipality;
      _certificateInailDto.perHHealthDistrict = $scope.certData.personal.home.healthDistrict;
      _certificateInailDto.perHProv = $scope.certData.personal.home.province;
    }
  }
  if ($scope.certData.personal.legal) {
    if ($scope.certData.personal.legal) {
      if ($scope.certData.personal.legal.residenzaEstera) _certificateInailDto.perLForeign = $scope.certData.personal.legal.residenzaEstera.id;
      _certificateInailDto.perLAddress = $scope.certData.personal.legal.address;
      _certificateInailDto.perLAddressNumber = $scope.certData.personal.legal.addressNumber;
      _certificateInailDto.perLAddressZip = $scope.certData.personal.legal.zipCode;
      _certificateInailDto.perLMunicipality = $scope.certData.personal.legal.municipality;
      _certificateInailDto.perLHealthDistrict = $scope.certData.personal.legal.healthDistrict;
      _certificateInailDto.perLProv = $scope.certData.personal.legal.province;
    }
  }
  _certificateInailDto.cerMunicipality = $scope.certData.certificate.municipality;
  _certificateInailDto.cerReleaseDate = $scope.certData.certificate.releaseDate;
  _certificateInailDto.cerType = $scope.certData.certificate.type.id;
  _certificateInailDto.cerPrognosisType = $scope.certData.certificate.prognosisType.id;
  _certificateInailDto.cerDateFrom = $scope.certData.certificate.dateFrom;
  _certificateInailDto.cerDateTo = $scope.certData.certificate.dateTo;
  _certificateInailDto.cerTemporaryReadmission = $scope.certData.certificate.temporaryReadmission;
  _certificateInailDto.cerDeadlyCase = $scope.certData.certificate.deadlyCase;
  _certificateInailDto.cerAutopsyRequested = $scope.certData.certificate.autopsyRequested;
  _certificateInailDto.cerDiagnosis = $scope.certData.certificate.diagnosis;
  _certificateInailDto.cerObjexamination = $scope.certData.certificate.objectiveExamination;
  _certificateInailDto.cerExams = $scope.certData.certificate.exams;
  _certificateInailDto.cerOtherexams = $scope.certData.certificate.otherExams;
  _certificateInailDto.cerObservations = $scope.certData.certificate.observations;
  _certificateInailDto.cerLifethreat = $scope.certData.certificate.lifeThreat;
  _certificateInailDto.cerPermanenthandicap = $scope.certData.certificate.permanentHandicap;
  _certificateInailDto.cerHospitalization = $scope.certData.certificate.hospitalization;
  _certificateInailDto.cerHospital = $scope.certData.certificate.hospital;
  _certificateInailDto.cerRetired = $scope.certData.certificate.retired;
  _certificateInailDto.cerDisabled = $scope.certData.certificate.disabled;
  _certificateInailDto.cerCertificateother = $scope.certData.certificate.certificateOther;
  _certificateInailDto.cerSpecification = $scope.certData.certificate.specification;
  _certificateInailDto.cerTranscribed = $scope.certData.certificate.transcribed;
  _certificateInailDto.doctor = $scope.certData.certificate.medic;
  _certificateInailDto.evtMunicipality = $scope.certData.event.municipality;
  _certificateInailDto.evtDate = $scope.certData.event.date;
  _certificateInailDto.evtDatehourLeave = $scope.certData.event.datehourLeave;
  _certificateInailDto.evtCircumstances = $scope.certData.event.circumstances;
  _certificateInailDto.evtTask = $scope.certData.event.task;
  _certificateInailDto.evtPreviousTasks = $scope.certData.event.previousTasks;
  _certificateInailDto.evtHasConsequences = $scope.certData.event.hasConsequences;
  _certificateInailDto.evtConsequencesDescription = $scope.certData.event.consequencesDescription;
  _certificateInailDto.evtVerifications = $scope.certData.event.verifications;
  _certificateInailDto.evtPrescriptions = $scope.certData.event.prescriptions;
  _certificateInailDto.cerProv = $scope.certData.certificate.province;
  _certificateInailDto.evtProv = $scope.certData.event.province;
  _certificateInailDto.evtIstat = $scope.certData.event.istat;
  _certificateInailDto.empBranch = $scope.certData.employer.branch.id;
  _certificateInailDto.empCompanyName = $scope.certData.employer.companyName;
  _certificateInailDto.empCompanyAddress = $scope.certData.employer.companyAddress;
  _certificateInailDto.empCompanyAddressNumber = $scope.certData.employer.companyAddressNumber;
  _certificateInailDto.empMunicipality = $scope.certData.employer.municipality;
  _certificateInailDto.empZip = $scope.certData.employer.zip;
  _certificateInailDto.empBirthProv = $scope.certData.employer.birthProvince;
  _certificateInailDto.empIstat = $scope.certData.employer.istat;
  return _certificateInailDto;
}
