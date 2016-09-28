<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicacommon.jsp,v 1.1 2008/05/28 02:09:30 lil Exp $" -->
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<script language="JavaScript">
// function for change replication timing, all|onlysnap|curdata
function onChangeRepliTiming() {
	if (document.getElementById("curdata").checked) {
		disableSnapKeepOption(true);		
	} else {
		disableSnapKeepOption(false);	
	}
}

function disableSnapKeepOption(flag) {
    // flag is true or false
	var useSnapKeepChkbox = document.forms[0].elements["replicaInfo.useSnapKeep"];
	var snapKeepLimitObj = document.forms[0].elements["replicaInfo.snapKeepLimit"];
	if (flag) {
		useSnapKeepChkbox.checked  = false;
		useSnapKeepChkbox.disabled = true;
	} else {
		useSnapKeepChkbox.disabled = false;
	}
	onUseSnapKeep(useSnapKeepChkbox);
}
// function for change use snap-keep mode's checkbox
function onUseSnapKeep(useSnapKeepChkbox) {
 	var snapKeepLimitObj = document.forms[0].elements["replicaInfo.snapKeepLimit"];
	if (useSnapKeepChkbox.checked) {
		snapKeepLimitObj.disabled = false;			
	} else {
		snapKeepLimitObj.disabled = true;
	}
}

function checkSnapKeepLimit() {
	var snapKeepLimitObj = document.forms[0].elements["replicaInfo.snapKeepLimit"];
	var snapKeepLimit = trim(snapKeepLimitObj.value);
	snapKeepLimitObj.value = snapKeepLimit;
	
	// not input snapkeep limit
	if (snapKeepLimit == "") {
		alert("<bean:message key="replication.snapKeepLimit.notSpecified"/>");
        snapKeepLimitObj.focus();
        return false;	    
	}
	
	// snapkeep limit is invalid
	var invalidCharSet = /[^0-9]/;
	if (snapKeepLimit.search(invalidCharSet) != -1) {
		alert("<bean:message key="replication.snapKeepLimit.invalid"/>");
        snapKeepLimitObj.focus();
        return false;
	}
	
	// transfer snapkeep limit to decimal number and set the value to textbox
	snapKeepLimit = parseInt(snapKeepLimit, 10);
	snapKeepLimitObj.value = snapKeepLimit;
	// snapshot limit is not between 1 and 254
    if ((snapKeepLimit < 1) 
        || (snapKeepLimit > parseInt(<%=ReplicationActionConst.MAX_SNAPSHOT_NUM%>))) {
		alert("<bean:message key="replication.snapKeepLimit.invalid"/>");
        snapKeepLimitObj.focus();
        return false;
    }
    
    return true;
}
</script>