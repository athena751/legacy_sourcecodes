/**
 *
 *       Copyright (c) 2001 NEC Corporation
 *
 *       NEC SOURCE CODE PROPRIETARY
 *
 *       Use, duplication and disclosure subject to a source code
 *       license agreement with NEC Corporation.
 *       "@(#) $Id: nfscommon.js,v 1.3 2004/09/08 13:23:37 het Exp $"
 */
 
function resetStatus(myWindow){
    resetNisDomain(myWindow);
    resetSubMountAndUserMapping(myWindow);
}

function resetNisDomain(myWindow){
    if(myWindow.isSxfsfw){
	    if(myWindow.seletedNisDomain4Win != ''){
            myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].value = myWindow.seletedNisDomain4Win;
       	}else{
            myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].value = myWindow.seletedNisDomain;
       	}
    }else{
        if(myWindow.seletedNisDomain != ''){
            myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].value = myWindow.seletedNisDomain;
       	}else{
       	    myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].value = myWindow.seletedNisDomain4Win;
       	}
    }	
    if(myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].value == ''
    	&& myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].options.length > 1){
    	myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].value = 
    	 	myWindow.document.forms[0].elements["detailInfo.seletedNisDomain"].options[1].value;
    }
}
function resetSubMountAndUserMapping(myWindow){
    if(myWindow.isSxfsfw){
        myWindow.document.forms[0].um[0].disabled = true;
        if(myWindow.document.forms[0].um[0].checked == true){
	        myWindow.document.forms[0].um[2].checked = true;
	    }
		if(myWindow.document.forms[0].um[1].checked == true){
		    if(myWindow.needAuthDomain || myWindow.needNativeDomain){
	        	myWindow.document.forms[0].um[2].checked = true;
	       	}
	    }
    }else{
    	if(myWindow.document.forms[0].um[1].checked == true){
		    if(myWindow.needAuthDomain || myWindow.needNativeDomain){
	        	myWindow.document.forms[0].um[0].checked = true;
	       	}
	    }
        myWindow.document.forms[0].um[0].disabled = false;
    }
    myWindow.onChangeClient();
    if(myWindow.isSubMountPoint){
        myWindow.document.forms[0].hide.disabled = false; 
    }else{
        myWindow.document.forms[0].hide.disabled = true;
    }
}
function resetMountAndMapStatus(myWindow){
	if(myWindow.isSxfsfw){
        myWindow.document.forms[0].um[0].disabled = true;
    }else{
        myWindow.document.forms[0].um[0].disabled = false;
    }
    if(myWindow.isSubMountPoint){
        myWindow.document.forms[0].hide.disabled = false; 
    }else{
        myWindow.document.forms[0].hide.disabled = true;
    }
}