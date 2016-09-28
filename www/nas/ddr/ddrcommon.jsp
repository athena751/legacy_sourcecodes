<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ddrcommon.jsp,v 1.3 2008/04/30 10:06:31 pizb Exp $" -->

<script language="JavaScript">
// display pairinfo list
function loadDdrPairList() {
    if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    lockMenu();
    window.location="/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairList.do?operation=display&doNotClear=yes";
    return true;
}

// set btnframe with blank page when bottomframe unloading
function unloadBtnFrame() {
    if (parent.btnframe){
        parent.btnframe.location="/nsadmin/common/commonblank.html";
    }    
}

// disable specified document's input.
function disableInputElement(doc, type){
	if (doc && doc.getElementsByTagName("INPUT")){
		var allInputs = doc.getElementsByTagName("INPUT");
	    for(var i=0;i<allInputs.length;i++){
	    	if ( !type || type == "" || type == "all"){
	    		allInputs[i].disabled = true;
	    	}
	    	else if ( type && allInputs[i].type == type ){
	    		allInputs[i].disabled = true;
	    	}
	    }
	}
}
</script>