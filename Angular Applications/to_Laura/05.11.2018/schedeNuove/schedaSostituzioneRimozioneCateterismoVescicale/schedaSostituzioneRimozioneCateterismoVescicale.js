var elementi = {
  dataRivalutazione: 'formCCE:l0s1d1r1',
  Utente: 'formCCE:l0s1d2r1',
  combi: 'formCCE:l0s2d1',
  s2s1: {
    id: 'formCCE:s2s1',
    dataRimozione: 'formCCE:l1s1d1r1',
    caratteristicheUrine: 'formCCE:l1s1d2r1',
    quantitaUrine: 'formCCE:l1s1d3r1',
    note: 'formCCE:l1s1d4r1'
  },
  s2s2: {
    id: 'formCCE:s2s2',
    cateterismo: 'formCCE:l1s2d1r1',
    indicazioni: ['formCCE:l1s2d2r1_input', 'formCCE:l1s2d2r2_input', 'formCCE:l1s2d2r3_input'],
    tipoDiCatetere: 'formCCE:l1s2d3r1',
    dataRimozione: 'formCCE:l1s2d4r1',
    calibro: 'formCCE:l1s2d5r1',
    caratteristicheUrine: 'formCCE:l1s2d6r1',
    diuresiParziale: 'formCCE:l1s2d7r1',
    vie: 'formCCE:l1s2d8'
  }
};


/* START* Svilupando*/
function controller() {
  init();
  showSectionByCombo();
}

function init() {
  if (!get_oggetto_id(elementi.dataRivalutazione).find('input').val()) {
    get_oggetto_id(elementi.dataRivalutazione).find('input').val(nowDateTime());
  }
}

function showSectionByCombo() {
  if (getIndexElementoAttivo(get_oggetto_nome(elementi.combi)) == 1) {
    get_oggetto_id(elementi.s2s2.id).removeClass('ui-comp-hidden');
    get_oggetto_id(elementi.s2s1.id).addClass('ui-comp-hidden');
  } else {
    get_oggetto_id(elementi.s2s1.id).removeClass('ui-comp-hidden');
    get_oggetto_id(elementi.s2s2.id).addClass('ui-comp-hidden');
  }
};

function onChangeComboCateterismo() {
  var valCateterismo = get_oggetto_id(elementi.s2s2.cateterismo).find('select').val();
  switch (valCateterismo) {
    case "A_BREVE":
      console.log("on azioni di A_BREVE");
      cancellaValoreCombo(elementi.s2s2.indicazioni, 1);
      contrassegno(elementi.s2s2.vie, -1);
      contrassegnoInputSelect(get_oggetto_id(elementi.s2s2.tipoDiCatetere), 0);
      contrassegnoInputSelect(get_oggetto_id(elementi.s2s2.calibro), 0);
      // cancellaValoreItem(elementi.s2s2.caratteristicheUrine);
      // cancellaValoreItem(elementi.s2s2.diuresiParziale);
      break;
    case "A_MEDIO":
      console.log("on azioni di A_MEDIO");
      cancellaValoreCombo(elementi.s2s2.indicazioni, 2);
      contrassegno(elementi.s2s2.vie, -1);
      contrassegnoInputSelect(get_oggetto_id(elementi.s2s2.tipoDiCatetere), 0);
      contrassegnoInputSelect(get_oggetto_id(elementi.s2s2.calibro), 0);
      // cancellaValoreItem(elementi.s2s2.caratteristicheUrine);
      // cancellaValoreItem(elementi.s2s2.diuresiParziale);
      break;
    case "ESTEMPORANEO":
      console.log("on azioni di ESTEMPORANEO");
      cancellaValoreCombo(elementi.s2s2.indicazioni, 0);
      contrassegno(elementi.s2s2.vie, 0);
      contrassegnoInputSelect(get_oggetto_id(elementi.s2s2.tipoDiCatetere), 1);
      contrassegnoInputSelect(get_oggetto_id(elementi.s2s2.calibro), 1);
      // cancellaValoreItem(elementi.s2s2.caratteristicheUrine);
      // cancellaValoreItem(elementi.s2s2.diuresiParziale);
      break;
    default:
      console.log("on azioni di default");
      cancellaValoreCombo(elementi.s2s2.indicazioni, 0);
  }
};

function onChangeComboTipoCatetere(){
  var valTipoCatetere = get_oggetto_id(elementi.s2s2.tipoDiCatetere).find('select').val();
  switch (valTipoCatetere) {
    case "Silicone_Ambrato":

      break;
    case "Foley":

      break;
    case "nelaton":

      break;
    case "Tiemann":

      break;
    case "Tiemann_Ambra":

      break;
    default:

  }
}
/* END* Svilupando*/

/* START*  Functions Utilities @Binni */
function getIndexElementoAttivo(gruppoRadio) {
  // RETURN [1..n] or null.
  // 1.- Fa un RETURN della posizione del radio attivo.
  // 2.- SI non trova nessuno RETURN = null.
  var elementi, indexElement;
  elementi = gruppoRadio;
  elementi.each(function(index, el) {
    if ($(this).prop('checked')) {
      indexElement = index;
      return false;
    }
  });
  if (indexElement == -1) {
    return indexElement = null;
  } else {
    return indexElement;
  }
};

function toTimestamp(testoData) {
  var day = testoData.substr(0, 2),
    moth = testoData.substr(3, 2),
    year = testoData.substr(6, 4),
    hour = testoData.substr(11, 2),
    min = testoData.substr(14, 2),
    seg = testoData.substr(17, 2);

  if (testoData.length < 19) {
    hour = testoData.substr(10, 2),
      min = testoData.substr(13, 2),
      seg = testoData.substr(16, 2);
  }
  console.log(year + moth + day + hour + min + seg);
  var data = new Date(year, moth - 1, day, hour, min, seg);
  return data / 1000;
}

function sommaGiorni(testoData, giorni) {
  //se requiere de un validador para el primer zero
  var day = testoData.substr(0, 2),
    moth = testoData.substr(3, 2),
    year = testoData.substr(6, 4),
    hour = testoData.substr(11, 2),
    min = testoData.substr(14, 2),
    seg = testoData.substr(17, 2);

  if (testoData.length < 19) {
    hour = testoData.substr(10, 2),
      min = testoData.substr(13, 2),
      seg = testoData.substr(16, 2);
  }
  console.log(year + moth + day + hour + min + seg);
  var data = new Date(year, moth - 1, day, hour, min, seg);
  console.log(data);
  data.setDate(data.getDate() + giorni);
  console.log(data);
  var nYear = data.getFullYear(),
    nMoth = metteZeroPrima(parseInt(data.getMonth()) + 1),
    nDay = metteZeroPrima(parseInt(data.getDate()));
  console.log(nDay + "/" + nMoth + "/" + nYear + " " + hour + ":" + min + ":" + seg);
  return nDay + "/" + nMoth + "/" + nYear + " " + hour + ":" + min + ":" + seg;
};

function metteZeroPrima(numero) {
  var risposta = '';
  if (numero < 10) {
    risposta = '0' + numero;
  } else {
    risposta = numero;
  }
  return risposta;
}


function get_oggetto_id(id) {
  //RETURN oggetto o gruppo di oggeti trovato per id.
  var object;
  object = $('[id=\"' + id + '\"]');
  return object;
}

function get_oggetto_nome(nome) {
  //RETURN oggetto o gruppo di oggeti trovato per nome.
  var object;
  object = $('[name=\"' + nome + '\"]');
  return object;
}

function get_oggetto_query(etichetta, query) {
  //etichetta : qualche etichetta  dentro del DOM. Esempi : ['div','input','textarea','button','a','label']
  //query : query per selezionare i elementi che sotisfaciano i requisiti. Esempi : ['id^="form_"', 'class*="button"', 'name$="_input"']
  var object;
  if (etichetta) {
    object = $(etichetta + '[' + query + ']');
  } else {
    object = $('[' + query + ']');
  }
  return object;
}

function cancellaValore(elemento) {
  elemento.val(null);
}

function contrassegnaValoreCombo(idCombo, itemPosition) {
  // Primo Parametro : prende il id del combo (che è il ID del DIV del combo).
  // Secondo Parametro : prende il numero di OPTION da attivare.
  var gruppoElementiCombo = $('[id=\"' + idCombo + '\"]');
  var select = gruppoElementiCombo.find('select');
  var optionSelect = select.find('option');
  var optionValue = "",
    optionText = "";
  optionSelect.each(function(index, el) {
    if (index == itemPosition) {
      optionValue = $(this).val();
      optionText = $(this).text();
      return false;
    };
  });
  var label = gruppoElementiCombo.find('label');
  label.text(optionText);
  select.val(optionValue);
  console.log("Se ha fatto il cambio dentro del combo : " + idCombo);
}

function cancellaValoreCombo(idCombo) {
  // Primo Parametro : prende il id del combo (che è il ID del DIV del combo).
  var gruppoElementiCombo = $('[id=\"' + idCombo + '\"]');
  gruppoElementiCombo.find('select').val("");
  gruppoElementiCombo.find('label').text("");
}



function contrassegno(gruppo, attivaRadio) {
  var elemento = document.getElementById(gruppo); // <-- ID tabella  contenitora di radio!!!
  console.log("Recibido :" + gruppo);

  var uiRadioBtn;
  //Prima pulito.
  $(elemento).find('.ui-radiobutton').find('.ui-radiobutton-box').removeClass('ui-state-active');
  $(elemento).find('.ui-radiobutton').find('input[name=\"' + gruppo + '\"]').prop('checked', false);
  $(elemento).find('.ui-radiobutton').find('.ui-radiobutton-box').find('.ui-radiobutton-icon').removeClass('ui-icon').removeClass('ui-icon-bullet');

  //luogo i valori sono caricati.
  uiRadioBtn = $(elemento).find('.ui-radiobutton')[attivaRadio];
  $(uiRadioBtn).find('.ui-radiobutton-box').addClass('ui-state-active');
  $(uiRadioBtn).find('input[name=\"' + gruppo + '\"]').prop('checked', true);
  $(uiRadioBtn).find('.ui-radiobutton-box').find('.ui-radiobutton-icon').addClass('ui-icon').addClass('ui-icon-bullet');
};

function cancellaValoreCombo(listaNomiInputCombo, itemAttivo) {
  var gruppo, LabelSelect;
  for (var i = 0; i < listaNomiInputCombo.length; i++) {
    LabelSelect = listaNomiInputCombo[i].substr(0, listaNomiInputCombo[i].length - 5) + "label";
    gruppo = listaNomiInputCombo[i].substr(0, listaNomiInputCombo[i].length - 6);
    if (i != itemAttivo) {
      $('select[name=\"' + listaNomiInputCombo[i] + '\"]').val("");
      $('label[id=\"' + LabelSelect + '\"]').text("");
      $('div[id=\"' + gruppo + '\"]').parent('td').addClass('ui-comp-hidden');
    } else {
      $('div[id=\"' + gruppo + '\"]').parent('td').removeClass('ui-comp-hidden');
    }
  }
};

function cancellaValoreItem(idItem) {
  $('[id=\"' + idItem + '\"]').val(null);
}

function contrassegnoInputSelect(oggettoTableSelect, indexAttivaItem) {
  var options = $(oggettoTableSelect).find('option');
  var selectedItem = $(options[indexAttivaItem]);
  $(oggettoTableSelect).find('select').val(selectedItem.val());
  $(oggettoTableSelect).find('label').text(selectedItem.text());
}
/* EMD*  Functions Utilities @Binni */
