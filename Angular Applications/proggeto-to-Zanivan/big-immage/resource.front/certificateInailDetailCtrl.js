(function() {
'use strict';

angular.module('HIS').controller('certificateInailDetailCtrl', certificateInailDetailCtrl);


	function certificateInailDetailCtrl($rootScope, $scope, $q, $sce, $uibModal, ResourceService, $uibModalInstance, $filter, $translate,
		APIService, $window, UtilsService, selectedPatient, certType, notify, WizardHandler, InailRestService, viewMode, ReportsRestService,
		certificate, $state, encounterId) {

		$scope.view = 'home';
		var ctrl = this;

		$scope.certificate=certificate;
		$scope.users = [];
		$scope.doctors = [];
		ctrl.currentStepIndex=0;
		$scope.isModifying=false;
		$scope.viewMode = viewMode;
		$scope.certType = certType;
		$scope.requirementsEnabled=true;
		$scope.readOnly=false;


		$scope.genders = [
			{id:"M", value:"M"},
			{id:"F", value:"F"}
		];

		$scope.yesNo = [
			{id:true, value:"inail.radio.yes"},
			{id:false, value:"inail.radio.no"}
		];

		$scope.certificateTypes = [
			{id:"FIRST"},
			{id:"CONTINUOUS"},
			{id:"FINAL"}
		];
		for(var i=0;i<$scope.certificateTypes.length;i++){
			$scope.certificateTypes[i].value=$translate.instant("inail.certificateTypes."+$scope.certificateTypes[i].id);
		}

		$scope.prognosisTypes = [
			{id:"NONE"},
			{id:"NORMAL"},
			{id:"RESERVED"}
		];
		for(var i=0;i<$scope.prognosisTypes.length;i++){
			$scope.prognosisTypes[i].value=$translate.instant("inail.prognosis."+$scope.prognosisTypes[i].id);
		}

		$scope.jobBranches = [
			{id:"I"},
			{id:"A"},
			{id:"S"},
			{id:"X"},
			{id:"Y"},
			{id:"Z"}
		];
		for(var i=0;i<$scope.jobBranches.length;i++){
			$scope.jobBranches[i].value=$translate.instant("inail.jobBranches."+$scope.jobBranches[i].id);
		}

		$scope.datePickerBirthDate = {
			opened: false,
			format: "dd/MM/yyyy",
			dateOptions: {
				formatYear: 'yyyy',
				startingDay: 1,
				minDate: new Date()
			}
		};

		$scope.datePickerReleaseDate = JSON.parse(JSON.stringify( $scope.datePickerBirthDate ));
		$scope.datePickerCertificateDateFrom = JSON.parse(JSON.stringify( $scope.datePickerBirthDate ));
		$scope.datePickerCertificateDateTo = JSON.parse(JSON.stringify( $scope.datePickerBirthDate ));
		$scope.datePickerEvtDate = {
			opened: false,
			format: "dd/MM/yyyy",
			dateOptions: {
				formatYear: 'yyyy',
				startingDay: 1,
				minDate: new Date()
			}
		};
		$scope.datePickerEvtDatehourLeave = {
			opened: false,
			format: "dd/MM/yyyy",
			dateOptions: {
				formatYear: 'yyyy',
				startingDay: 1,
				minDate: new Date()
			}
		};

		$scope.$watch('certData.certificate.dateFrom', function (newValue, oldValue) {
			$scope.datePickerCertificateDateTo.dateOptions.minDate = newValue;
		});
		$scope.$watch('certData.certificate.dateTo', function (newValue, oldValue) {
			$scope.datePickerCertificateDateFrom.dateOptions.maxDate = newValue;
		});

		$scope.$on('wizard:stepChanged',function(event, args) {
			ctrl.currentStepIndex = args.index;
		});


		var buildCertificateInailDto = function () {

			var _certificateInailDto = {};
			_certificateInailDto.id = $scope.certData.id;
			_certificateInailDto.encounterId=$scope.certData.encounterId;
			_certificateInailDto.doctor={};

			_certificateInailDto.statusCode = $scope.certData.status;
			_certificateInailDto.lastextraction=$scope.certData.lastextraction;
			_certificateInailDto.extracted=$scope.certData.extracted;
			_certificateInailDto.perLastName = $scope.certData.personal.lastName;
			_certificateInailDto.perFirstName = $scope.certData.personal.firstName;
			_certificateInailDto.perUniqueIdentifier = $scope.certData.personal.uniqueIdentifier;
			_certificateInailDto.perBirthDate = $scope.certData.personal.birthDate;
			_certificateInailDto.perGender = $scope.certData.personal.gender.id;
			_certificateInailDto.perBirthPlace = {};
			_certificateInailDto.perBirthPlace = $scope.certData.personal.birthPlace;
			_certificateInailDto.perNationality = $scope.certData.personal.nationality;
			_certificateInailDto.perIstat = $scope.certData.personal.istat;

			if($scope.certData.personal.absent) _certificateInailDto.perAbsent = $scope.certData.personal.absent.id;
			_certificateInailDto.perTel1Acode = $scope.certData.personal.phone_areaCode;
			_certificateInailDto.perTel1Number = $scope.certData.personal.phone;
			_certificateInailDto.perTel2Acode = $scope.certData.personal.mobilePhone_areaCode;
			_certificateInailDto.perTel2Number = $scope.certData.personal.mobilePhone;
			_certificateInailDto.perBirthProv = $scope.certData.personal.birthProvince;




			if($scope.certData.personal.home){
				if($scope.certData.personal.home){
					if($scope.certData.personal.home.residenzaEstera) _certificateInailDto.perHForeign = $scope.certData.personal.home.residenzaEstera.id;
					_certificateInailDto.perHAddress = $scope.certData.personal.home.address;
					_certificateInailDto.perHAddressNumber = $scope.certData.personal.home.addressNumber;
					_certificateInailDto.perHAddressZip = $scope.certData.personal.home.zipCode;
					_certificateInailDto.perHMunicipality = $scope.certData.personal.home.municipality;
					_certificateInailDto.perHHealthDistrict = $scope.certData.personal.home.healthDistrict;
					_certificateInailDto.perHProv = $scope.certData.personal.home.province;
				}
			}

			if($scope.certData.personal.legal){
				if($scope.certData.personal.legal){
					if($scope.certData.personal.legal.residenzaEstera) _certificateInailDto.perLForeign = $scope.certData.personal.legal.residenzaEstera.id;
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


		function init() {

			$scope.currentUser = ResourceService.getCurrentUser();
			$scope.certData = {};
			$scope.selectedDiagnosis=null;
			$scope.CLASSNAME = "CERTIFICATE";

			$scope.doctors.push($scope.currentUser.healthCareProvider);

			if($scope.viewMode=="NEW"){

				$scope.certData = {
					encounterId: encounterId,
					status: "DRAFT",
					extracted: false,
					personal:	{
									lastName: selectedPatient.lastName,
									firstName: selectedPatient.firstName,
									uniqueIdentifier: selectedPatient.uniqueIdentifier,
									birthDate: selectedPatient.birthDate,
									gender: $scope.genders.filter(function (obj) { return obj.id === selectedPatient.sex; })[0],
									birthPlace: selectedPatient.birthPlace,
									nationality: selectedPatient.nationality,
									istat: null,
									absent: $scope.yesNo[1],
									phone: selectedPatient.phone,
									mobilePhone: selectedPatient.mobilePhone,
									birthProvince: selectedPatient.birthPlace? selectedPatient.birthPlace.province : null

								},
					certificate:{
						type: $scope.certificateTypes.filter(function (obj) { return obj.id === "FIRST"; })[0],
						prognosisType: $scope.prognosisTypes.filter(function (obj) { return obj.id === "NONE"; })[0],
						medic: $scope.doctors.filter(function (obj) { return obj.id === $scope.currentUser.healthCareProvider.id; })[0]
					},
					event:		{},
					employer:	{
						branch: {id:"I"}
					}



				};


				$scope.certData.personal.home = {};
				$scope.certData.personal.legal = {};
				$scope.certData.personal.home.residenzaEstera=$scope.yesNo[1];
				$scope.certData.personal.legal.residenzaEstera=$scope.yesNo[1];

				if(selectedPatient.addresses && selectedPatient.addresses[0]){
					$scope.certData.personal.home.address=selectedPatient.addresses[0].address;
					$scope.certData.personal.home.addressNumber= selectedPatient.addresses[0].addressNumber;
					$scope.certData.personal.home.municipality= selectedPatient.addresses[0].municipality;
					//$scope.certData.personal.home.province=null;
					$scope.certData.personal.home.zipCode=selectedPatient.addresses[0].zipCode;
					$scope.certData.personal.home.healthDistrict=selectedPatient.healthDistrict;
				}

				if(selectedPatient.addresses && selectedPatient.addresses[1]){
					$scope.certData.personal.legal.address = selectedPatient.addresses[1].address;
					$scope.certData.personal.legal.addressNumber = selectedPatient.addresses[1].addressNumber;
					$scope.certData.personal.legal.municipality = selectedPatient.addresses[1].municipality;
					//$scope.certData.personal.legal.province = null;
					$scope.certData.personal.legal.zipCode = selectedPatient.addresses[1].zipCode;
					//$scope.certData.personal.legal.healthDistrict = null;
				}

			}else if($scope.viewMode=="VIEW"){

				$scope.certData = {

					id: $scope.certificate.id,
					encounterId: $scope.certificate.encounterId,
					status: $scope.certificate.statusCode,
					lastextraction: $scope.certificate.lastextraction,
					extracted: $scope.certificate.extracted,
					extractionUser: $scope.certificate.extractionUser,

					personal:	{
									lastName: $scope.certificate.perLastName,
									firstName: $scope.certificate.perFirstName,
									uniqueIdentifier: $scope.certificate.perUniqueIdentifier,
									birthDate: $scope.certificate.perBirthDate? new Date($scope.certificate.perBirthDate):null,
									gender: $scope.genders.filter(function (obj) { return obj.id === $scope.certificate.perGender;})[0],
									birthPlace: $scope.certificate.perBirthPlace,
									nationality: $scope.certificate.perNationality,
									absent: $scope.yesNo.filter(function (obj) { return obj.id === $scope.certificate.perAbsent;})[0],
									phone_areaCode: $scope.certificate.perTel1Acode,
									phone: $scope.certificate.perTel1Number,
									mobilePhone_areaCode: $scope.certificate.perTel2Acode,
									mobilePhone: $scope.certificate.perTel2Number,
									birthProvince: $scope.certificate.perBirthProv,
									istat: $scope.certificate.perIstat,

									home: {
										residenzaEstera: $scope.yesNo.filter(function (obj) { return obj.id === $scope.certificate.perHForeign;})[0],
										address: $scope.certificate.perHAddress,
										addressNumber: $scope.certificate.perHAddressNumber,
										municipality: $scope.certificate.perHMunicipality,
										zipCode: $scope.certificate.perHAddressZip,
										healthDistrict: $scope.certificate.perHHealthDistrict,
										province: $scope.certificate.perHProv
									},

									legal: {
										residenzaEstera: $scope.yesNo.filter(function (obj) { return obj.id === $scope.certificate.perLForeign;})[0],
										address: $scope.certificate.perLAddress,
										addressNumber: $scope.certificate.perLAddressNumber,
										municipality: $scope.certificate.perLMunicipality,
										zipCode: $scope.certificate.perLAddressZip,
										healthDistrict: $scope.certificate.perLHealthDistrict,
										province: $scope.certificate.perLProv
									}
								},

					certificate:{
						municipality: $scope.certificate.cerMunicipality,
						releaseDate: $scope.certificate.cerReleaseDate ? new Date($scope.certificate.cerReleaseDate) : null,
						type: $scope.certificateTypes.filter(function (obj) { return obj.id === $scope.certificate.cerType;})[0],
						prognosisType: $scope.prognosisTypes.filter(function (obj) { return obj.id === $scope.certificate.cerPrognosisType;})[0],
						dateFrom: $scope.certificate.cerDateFrom ? new Date($scope.certificate.cerDateFrom) : null,
						dateTo: $scope.certificate.cerDateTo ? new Date($scope.certificate.cerDateTo) : null,
						temporaryReadmission: $scope.certificate.cerTemporaryReadmission,
						deadlyCase: $scope.certificate.cerDeadlyCase,
						autopsyRequested: $scope.certificate.cerAutopsyRequested,
						diagnosis: $scope.certificate.cerDiagnosis,
						objectiveExamination: $scope.certificate.cerObjexamination,
						exams: $scope.certificate.cerExams,
						otherExams: $scope.certificate.cerOtherexams,
						observations: $scope.certificate.cerObservations,
						lifeThreat: $scope.certificate.cerLifethreat,
						permanentHandicap: $scope.certificate.cerPermanenthandicap,
						hospitalization: $scope.certificate.cerHospitalization,
						hospital: $scope.certificate.cerHospital,
						retired: $scope.certificate.cerRetired,
						disabled: $scope.certificate.cerDisabled,
						certificateOther: $scope.certificate.cerCertificateother,
						specification: $scope.certificate.cerSpecification,
						medic: $scope.certificate.doctor,
						transcribed: $scope.certificate.cerTranscribed,
						province: $scope.certificate.cerProv
					},

					event:		{
						municipality: $scope.certificate.evtMunicipality,
						date: $scope.certificate.evtDate ? new Date($scope.certificate.evtDate) : null,
						datehourLeave: $scope.certificate.evtDatehourLeave ? new Date($scope.certificate.evtDatehourLeave) : null,
						circumstances: $scope.certificate.evtCircumstances,
						task: $scope.certificate.evtTask,
						previousTasks: $scope.certificate.evtPreviousTasks,
						hasConsequences: $scope.certificate.evtHasConsequences,
						consequencesDescription: $scope.certificate.evtConsequencesDescription,
						verifications: $scope.certificate.evtVerifications,
						prescriptions: $scope.certificate.evtPrescriptions,
						province: $scope.certificate.evtProv,
						istat: $scope.certificate.evtIstat
					},

					employer:	{
						branch: $scope.jobBranches.filter(function (obj) { return obj.id === $scope.certificate.empBranch;})[0],
						companyName: $scope.certificate.empCompanyName,
						companyAddress: $scope.certificate.empCompanyAddress,
						companyAddressNumber: $scope.certificate.empCompanyAddressNumber,
						municipality: $scope.certificate.empMunicipality,
						zip: $scope.certificate.empZip,
						birthProvince: $scope.certificate.empBirthProv,
						istat: $scope.certificate.empIstat,
					}


				};

				$scope.certType = "INAIL_INJURY";

				if($scope.certData.status=="DRAFT"){
					$scope.readOnly=false;
				}else{
					$scope.readOnly=true;
				}

				if($scope.certData.certificate.medic.id != $scope.currentUser.healthCareProvider.id) $scope.readOnly=true;

			}
		}
		init();

		$scope.prognosisTypeChanged = function(){

			if($scope.certData.certificate.prognosisType.id!="NORMAL"){
				delete($scope.certData.certificate.dateFrom);
				delete($scope.certData.certificate.dateTo);
			}

		}

		$scope.municipalityChanged = function(source,value){

			if(source && value && value.province){
				switch(source){
					case "patient_birthPlace":  this.certData.personal.birthProvince=value.province;
												this.certData.personal.istat=value.registryCode;
												if(value.province.region) this.certData.personal.nationality=value.province.region.country;
												break;
					case "home_municipality":  	this.certData.personal.home.province=value.province;
												break;
					case "legal_municipality":  this.certData.personal.legal.province=value.province;
												break;
					case "certificate_municipality":  	this.certData.certificate.province=value.province;
														break;
					case "event_municipality":  this.certData.event.province=value.province;
												this.certData.event.istat=value.registryCode;
												break;
					case "employer_municipality":  	this.certData.employer.birthProvince=value.province;
													this.certData.employer.istat=value.registryCode;
													break;
				}
			}
		};

		$scope.provinceChanged = function(source,value){

			if(source && value && value.region){
				switch(source){
					case "birth_province":  if(value.region) this.certData.personal.nationality=value.region.country;
											break;
				}
			}
		};


		/*
			actions
		*/
		$scope.requestGoBack = function() {
			if(ctrl.currentStepIndex==0){

				if(!$scope.validationForm.$dirty){

					$uibModalInstance.close(null);

				}else{


					var buttons = [
						{
							visible: true,
							label: $translate.instant('inail.dialog.yes'),
							primary: false,
							onClick: "close",
							callback: function dialogYesCallback() {
								$scope.requestSave("DRAFT");
							}
						},
						{
							visible: true,
							label: $translate.instant('inail.dialog.no'),
							primary: true,
							onClick: "close",
							callback: function dialogNoCallback() {
								$uibModalInstance.close(null);
							}
						},
						{
							visible: true,
							label: $translate.instant('inail.dialog.cancel'),
							primary: false,
							onClick: "close"
						}
					];

					UtilsService.openPopup(
						$translate.instant("form.dirty.title"),
						$translate.instant("form.dirty.saveBeforeClose"),
						null,
						null,
						buttons
					);
				}

			}else{
				WizardHandler.wizard("inailWizard").previous();
			}
		};

		$scope.requestGoForward = function() {
			if(ctrl.currentStepIndex<3){
				WizardHandler.wizard("inailWizard").next();
			}
		};

		$scope.requestSave = function(statusCode){

			var _certificateInailDto = buildCertificateInailDto();
			var previousStatusCode=_certificateInailDto.statusCode;

			if(statusCode=="DRAFT" || statusCode=="VALIDATED"){
				_certificateInailDto.statusCode=statusCode;
			}

			InailRestService.createCertificate(_certificateInailDto).then(function (data) {
				notify.logSuccess($translate.instant('inail.certificateNotificationTitle_OK'),
					$translate.instant('inail.certificate_DRAFT_SuccessNotification') + " '" + $translate.instant('inail.certificateStates.'+data.statusCode)+"'");
					//if(previousStatusCode==statusCode && statusCode=="DRAFT")
					$uibModalInstance.close(null);
			}).catch(function(fallback){
				notify.logError($translate.instant("inail.certificateNotificationTitle_ErrorTitle"), $translate.instant("inail.notificationMessage_cannotSave")+": "+fallback.data.message);
				});
		}

		$scope.requestDelete = function() {

			UtilsService.openPopup($translate.instant("message_title_info"), $translate.instant("message_confirm_delete"), function () {
				InailRestService.cancelCertificate($scope.certData.id)
				.then(function(data){
					$uibModalInstance.close();
				})
				.catch(function(fallback){
					$scope.removePasswordFromStorage
					notify.logError($translate.instant("inps.certificateNotificationTitle_ErrorTitle"), $translate.instant("inps.notificationMessage_cannotDelete")+": "+fallback.data.message);
				});
			});
		}



		angular.element(document).ready(function () {
			$scope.validationForm.$dirty=false;
		});


		$scope.copyAddress = function() {
			$scope.certData.personal.legal=$scope.certData.personal.home;
		}

		$scope.noMobilePhone = function(){
			var result=false;
			if($scope.certData.personal.absent && $scope.certData.personal.absent.id) return result;
			if($scope.certData.personal.mobilePhone_areaCode==null) result=true;
			if($scope.certData.personal.mobilePhone_areaCode=="") result=true;
			if($scope.certData.personal.mobilePhone==null) result=true;
			if($scope.certData.personal.mobilePhone=="") result=true;
			return result;
		}

		$scope.noPhone = function(){
			var result=false;
			if($scope.certData.personal.absent && $scope.certData.personal.absent.id) return result;
			if($scope.certData.personal.phone_areaCode==null) result=true;
			if($scope.certData.personal.phone_areaCode=="") result=true;
			if($scope.certData.personal.phone==null) result=true;
			if($scope.certData.personal.phone=="") result=true;
			return result;
		}


		/*
			Button bar
		*/
		$scope.isButtonSaveDisabled = function() {
			var disabled = false;
			if($scope.readOnly) disabled=true;
			return disabled;
		}

		$scope.isButtonValidateDisabled = function(){
			var disabled=false;
			if($scope.certData.status=="VALIDATED") disabled=true;
			if($scope.readOnly) disabled=true;
			return disabled;
		}

		$scope.isButtonCancelDisabled = function() {
			var disabled = false;
			return disabled;
		}

		$scope.isButtonDraftDisabled = function() {
			var disabled = false;
			if($scope.certData.certificate.medic && $scope.certData.certificate.medic.id!=$scope.currentUser.healthCareProvider.id) disabled = true;
			if($scope.certData.status=="DRAFT") disabled=true;
			return disabled;
		};

		$scope.isButtonDeleteDisabled = function() {
			var disabled = false;
			//if($scope.readOnly) disabled=true;
			return disabled;
		};



		$scope.isButtonPrintDisabled = function() {
			var disabled = true;
			if($scope.certData.status=="VALIDATED") disabled=false;
			return disabled;
		}

		$scope.requestPrint = function() {

			//console.log("printing certificate n°"+$scope.certificate.id);

			ReportsRestService.generateReport('INAIL_CERTIFICATE', 'INAIL_CERTIFICATE', $scope.certificate.id, null, null, null).then(
				function successCallback(data) {
					if (data) {
						var filename = 'certificato_INAIL_' + $scope.certificate.id + ".pdf";
						var downloadUrl = RepositoryRestService.getDocumentDownloadUrl(data.downloadUUID, data.mimeType, filename, false);
						downloadUrl = $sce.trustAsResourceUrl(downloadUrl);
						$window.open(downloadUrl);
					}
				});
		};

	} // end main controller


})();
