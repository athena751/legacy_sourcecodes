/*
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volumecommon.js,v 1.5 2007/06/11 04:16:08 xingyh Exp $"
*/

/************* split string with "," ***************/
function splitString(strBefore) {
	var index = strBefore.indexOf(".");
	
	var strTail = "";
	if (index != -1) {
		strTail = strBefore.substr(index);
	} else {
		index = strBefore.length;
	}
	
	if (index <= 3) {
		return strBefore;
	}
	
	var strAfter = "";
	var tmpStr;
	while (index > 3) {
		tmpStr = strBefore.substr(index - 3, 3);
		
		if (strAfter == "") {
			strAfter = tmpStr;
		} else {
			strAfter = tmpStr + "," + strAfter;
		}
		
		index -= 3;
	}
    
	if (index != 0) {
		strAfter = strBefore.substr(0, index) + "," + strAfter;
	}
	
	if (strTail != "") {
		strAfter += strTail; 
	}
	
	return strAfter;
}
/*************************************************/

/********************delete all "," of the string*****************************/
function combinateStr(strBefore) {
	var reg = /,/g;
	var strAfter = strBefore.replace(reg, "");
	return strAfter;
}
/********************set Help url*****************************/

function checkWpPeriod(textObj) {
    var targetValue = trim(textObj.value);
    if(targetValue == ""){
        return false;
    }
    
    var unAvail = /[^0-9]/g;
    if(targetValue.search(unAvail)==-1){
        //the character specified is valid
        targetValue = parseInt(targetValue, 10);
        if((targetValue >= 1) && (targetValue <= 10950)){
            //valid period
            textObj.value = targetValue;
            return true;
        }
    }
    
    return false;
}
/********************disable all button *****************************/
function disableButtonAll(){
    for (var i = 0;i < window.document.forms.length; i++ ){
      for (var j = 0; j < window.document.forms[i].elements.length; j++){
           var object = window.document.forms[i].elements[j];
           if("button" == object.type||"submit" == object.type||"radio" == object.type){
               object.disabled = true;
           }
       } 
    }
}

/*********************check buildTime*********************************/
function isBlTimeValid(bltime, minVal, maxVal){
	var isinvalidtime="false";
    if (bltime.match(/[^\d]/)){
        isinvalidtime="true";
    }
    if (bltime.match(/^0/) && bltime.length>1){
        isinvalidtime="true";
    }
    var rbt=parseInt(bltime);
    if (isinvalidtime == "true" || isNaN(rbt)|| rbt <minVal || rbt >maxVal){
        return false;
    } 
    return true;
}