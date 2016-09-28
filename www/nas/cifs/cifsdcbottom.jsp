<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsdcbottom.jsp,v 1.3 2006/07/04 11:33:30 baiwq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-logic" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
    var logviewWin;
    
    function onReConnect() {
        if(isSubmitted()){
           return false;
       }
       if(confirm('<bean:message key="cifs.dc.confirmReconnect" />')) {
           setSubmitted();
           window.location="/nsadmin/cifs/cifsDC.do?operation=dcReConnect";
           return true;
       }
    }
    
    function onDisplayLog() {
    if (logviewWin != null && !logviewWin.closed){
        logviewWin.focus();
    }else{
        logviewWin = open("/nsadmin/common/commonblank.html","winName","resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=700,height=655,top=0,left=300");
    }
    document.forms[0].target = "winName";
    document.forms[0].action = "/nsadmin/cifs/displayDCLogFrame.do";
    document.forms[0].submit();
    return true;
    }
</script>
</head>
<body onload="displayAlert();"
	onunload="closePopupWin(logviewWin);window.parent.hiddenframe.window.location='/nsadmin/cgi/log_cleanTmpFile4onunload.pl?sessionID=<%=request.getSession().getId()%>'">
<form target="_parent" method="post">
<displayerror:error h1_key="cifs.common.h1" />
    <logic:equal
	    name="<%= NSActionConst.SESSION_USERINFO %>"
	    value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
	    <input name="reConnect" type="button"
		value="<bean:message key="cifs.dc.reConnect" />"
		onclick="return onReConnect();" />
    </logic:equal>
    <input name="displayLog" type="button"
	value="<bean:message key="cifs.dc.displayLog" />"
	onclick="onDisplayLog();" />
</form>
</body>
</html>