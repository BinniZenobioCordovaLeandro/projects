
var calcScalaNorton =  function (){
  var sommaNortonExton = sommaScore(formData.scalaExton);
  var msg="";

  if(sommaNortonExton == 0){
    msg= "";
  } else if(0 < sommaNortonExton && sommaNortonExton < 10 ){
    msg= "RISCHIO ALTISSIMO";
  } else if(sommaNortonExton < 12 ){
    msg= "RISCHIO ALTO";
  } else if(sommaNortonExton < 14 ){
    msg= "RISCHIO MEDIO";
  } else if(sommaNortonExton < 16 ){
    msg= "RISCHIO BASSO";
  } else {
    msg= "NESSUN RISCHIO";
  }

  formData.scoreTotal = sommaNortonExton;
  formData.indiceNortonExtonStato =msg;
};
registerFunction ("calcScalaNorton",calcScalaNorton);
var calcScalaNortonPlus =  function (){
  var sommaNortonValutazione = sommaScore(formData.valutazione);
  var sommaNortonExton = sommaScore(formData.scalaExton);
  var sommaNortonPlus = sommaNortonExton -  sommaNortonValutazione;
  var msg2="";

  if(sommaNortonPlus == 0){
    msg2= "";
  } else if(0 < sommaNortonPlus && sommaNortonPlus < 10 ){
    msg2= "RISCHIO ALTISSIMO";
  } else if(sommaNortonPlus < 12 ){
    msg2= "RISCHIO ALTO";
  } else if(sommaNortonPlus < 14 ){
    msg2= "RISCHIO MEDIO";
  } else if(sommaNortonPlus < 16 ){
    msg2= "RISCHIO BASSO";
  } else {
    msg2= "NESSUN RISCHIO";
  }
  formData.scoreTotalPlus = sommaNortonPlus;
  formData.indiceNortonPlusStato = msg2;
};
registerFunction ("calcScalaNortonPlus",calcScalaNortonPlus);

function sommaScore(target){
  var somma = 0, count = 0, element=null;
  for(var i in target){
    element = target[i];
    if(element.score){
      somma = somma + element.score;
    }
  }
  return  somma;
}
registerFunction ("calcScalaNortonPlus",calcScalaNortonPlus);

var selectedeRadio=function (event){
  if(formData.valutazione != changeJsonValutazione ){
    calcScalaNortonPlus();
  }
  if(formData.scalaExton != changeJsonScalaExton ){
    calcScalaNorton();
  }
 var changeJsonScalaExton = angular.copy(formData.scalaExton);
 var changeJsonValutazione = angular.copy(formData.valutazione);
};
registerFunction ("selectedeRadio",selectedeRadio);
