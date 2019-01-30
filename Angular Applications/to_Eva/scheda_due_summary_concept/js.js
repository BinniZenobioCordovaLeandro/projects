function init() {
  if (initData) {
    formData.patientId = initData.patient.patientId;
  }
}

viewData.info = false;
viewData.infoMessage = "";
viewData.alert = false;
viewData.alertMessage = "";
viewData.success = false;
viewData.successMessage = "";

var findFMConceptInstanceValue = function() {
  viewData.info = true;
  viewData.infoMessage = "eseguendo findFMConceptInstanceValue()";

  var conceptName = formData.conceptName;
  var templateName = formData.templateName;
  var templateVersion = formData.templateVersion;
  var dateFrom = formData.dateFrom ? new Date(formData.dateFrom).getFullYear() + "-"+ (new Date(formData.dateFrom).getMonth()+1)+"-"+new Date(formData.dateFrom).getDate() : null;
  var dateTo = formData.dateTo ? new Date(formData.dateTo).getFullYear() + "-"+ (new Date(formData.dateTo).getMonth()+1)+"-"+new Date(formData.dateTo).getDate() : null;
  var patientId = formData.patientId;
  var includeDraft = formData.includeDraft;
  // CustomAPIService.findFMConceptInstanceValue("conceptName", "templateName", "templateVersion", "Date: from ","Date: to ","patientId ","includeDraft ")
  CustomAPIService.findFMConceptInstanceValue(conceptName, templateName, templateVersion, dateFrom, dateTo, patientId, includeDraft).then(
    function successCallback(data) {
      console.log(data);
      viewData.info = false;
      viewData.alert = false;
      viewData.success = true;
      viewData.successMessage = "avviamo messo dati dentro della consola per te!";
    },
    function errorCallback(error) {
      viewData.info = false;
      viewData.success = false;
      viewData.alert = true;
      viewData.alertMessage = "vede l'errore nella consola.";
      console.log(error);
    });
};

var getLastConcept = function() {
  viewData.info = true;
  viewData.infoMessage = "eseguendo getLastConcept()";

  var conceptName = formData.conceptName;
  var templateName = formData.templateName;
  var templateVersion = formData.templateVersion;
  // var dateFrom = formData.dateFrom;
  // var dateTo = formData.dateTo;
  var patientId = formData.patientId;
  var includeDraft = formData.includeDraft;

  CustomAPIService.getLastFMConceptValue(conceptName, templateName, templateVersion, patientId, includeDraft).then(
    function successCallback(data) {
      console.log(data);
      viewData.info = false;
      viewData.alert = false;
      viewData.success = true;
      viewData.successMessage = "avviamo messo dati dentro della consola per te!";
    },
    function errorCallback(error) {
      viewData.info = false;
      viewData.success = false;
      viewData.alert = true;
      viewData.alertMessage = "vede l'errore nella consola.";
      console.log(error);
    });
};

var findFMConceptValue = function() {
  viewData.info = true;
  viewData.infoMessage = "eseguendo findFMConceptValue()";

  var conceptName = formData.conceptName;
  var templateName = formData.templateName;
  var templateVersion = formData.templateVersion;
  var dateFrom = formData.dateFrom ? new Date(formData.dateFrom).getFullYear() + "-"+ (new Date(formData.dateFrom).getMonth()+1)+"-"+new Date(formData.dateFrom).getDate() : null;
  var dateTo = formData.dateTo ? new Date(formData.dateTo).getFullYear() + "-"+ (new Date(formData.dateTo).getMonth()+1)+"-"+new Date(formData.dateTo).getDate() : null;
  var patientId = formData.patientId;
  var includeDraft = formData.includeDraft;

  CustomAPIService.findFMConceptValue(conceptName, templateName, templateVersion, dateFrom, dateTo, patientId, includeDraft).then(
    function successCallback(data) {
      console.log(data);
      viewData.info = false;
      viewData.alert = false;
      viewData.success = true;
      viewData.successMessage = "avviamo messo dati dentro della consola per te!";
    },
    function errorCallback(error) {
      viewData.info = false;
      viewData.success = false;
      viewData.alert = true;
      viewData.alertMessage = "vede l'errore nella consola.";
      console.log(error);
    });
};

registerFunction("findFMConceptInstanceValue", findFMConceptInstanceValue);
registerFunction("getLastConcept", getLastConcept);
registerFunction("findFMConceptValue", findFMConceptValue);

init();
