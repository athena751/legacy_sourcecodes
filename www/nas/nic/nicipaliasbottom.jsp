<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicipaliasbottom.jsp,v 1.2 2007/08/24 05:00:33 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>

<script language="JavaScript">

function onSet(){
    if(isSubmitted()){
        return false;
    } 
    parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.address"].value= trim(parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.address"].value);
    parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.gateway"].value= trim(parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.gateway"].value);
    if( !checkAliasNumber() || !checkIPAdress() || !checkGateway() ){
        return false;
    }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
                '<bean:message key="common.confirm.action" bundle="common"/>'+
    		    '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
    }
    setSubmitted();
    window.document.forms[0].set.disabled=1;
    parent.nicIPAliasTop.document.forms[0].submit();
}

function checkAliasNumber(){
    var aliasNumber = parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.alias"].value;
    if(!isValidDigit(aliasNumber,1,99)){
       alert("<bean:message key="nic.alert.message.alias.invalidvid"/>");
	   parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.alias"].focus();
	   return false;
	}
    return true;
}

function checkIPAdress(){
	var address = trim(parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.address"].value);
	var netmask = trim(parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.netmask"].value);
	var oldnetwork = trim(parent.nicIPAliasTop.document.forms[0].network.value);
	var newnetwork = getNetwork(address,netmask);
	if ( !checkIP(address) || address == "0.0.0.0" ) {
	    alert("<bean:message key="nic.interfaceChange.invalidIP" />");
		parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.address"].focus();
		return false;
	}
	if ( trim(newnetwork) != oldnetwork ){
	    alert("<bean:message key="nic.interfaceChange.invalidIP.net" />");
		parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.address"].focus();
        return false;
	}
    return true;
}
function checkGateway(){
	var gateway = trim(parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.gateway"].value);
	if(gateway == ""){
	} else if ( !checkIP(gateway) || gateway == "0.0.0.0" ) {
	    alert("<bean:message key="nic.interfaceChange.invalidGateway" />");
		parent.nicIPAliasTop.document.forms[0].elements["interfaceSet.gateway"].focus();
		return false;
	}
    return true;
}
function changeButtonStatus(){
   if((parent.nicIPAliasTop) && (parent.nicIPAliasTop.buttonEnable) && parent.nicIPAliasTop.buttonEnable == 1){
       document.forms[0].set.disabled = 0;
   }
}
</script>
</head>
<body  onload="changeButtonStatus();">
    <form name="nicIPAliasBottom">
        <input type="button" name="set" onclick="onSet();" value="<bean:message key="common.button.submit" bundle="common"/>" disabled>
    </form>
</body>
</html>
