<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttabnsviewbottom.jsp,v 1.1 2005/07/27 01:02:55 wangli Exp $" -->
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function clickAction(){
    if(isSubmitted()){
        return false;
    } 
    if(parent.accountTabnsviewTop.document.forms[0].checkconnection.checked == 1){
            if(!checkPasswd()){
                 parent.accountTabnsviewTop.document.forms[0]._nsviewpassword.focus();
                 return false;
                 }
             }
    if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
                '<bean:message key="common.confirm.action" bundle="common"/>'+
    		    '<bean:message key="common.button.submit" bundle="common"/>')){
        return false;
        }
    setSubmitted();
    window.document.forms[0].nsview_submit.disabled=1;
    parent.accountTabnsviewTop.document.forms[0].submit();
}

function checkPasswd(){
    var passwd = parent.accountTabnsviewTop.document.forms[0]._nsviewpassword.value;
    var passwdcheck = parent.accountTabnsviewTop.document.forms[0]._nsviewpasswordcheck.value;
    if(passwd == ""){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" 
        + "\r\n" + "<bean:message key="account.alert.nopasswd"/>");
        return false;
    }
    if(passwd.length < 6){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" 
        + "\r\n" + "<bean:message key="account.alert.tooshort"/>");
        return false;
    }
    if(passwd != passwdcheck){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" 
        + "\r\n" + "<bean:message key="account.alert.nomatch"/>");
        return false;
    }
    return true;
}
</script>
</head>
<body>
<form name="accountTabnsviewBottomForm">
<input type="button" name="nsview_submit" onclick="clickAction();" value="<bean:message key="common.button.submit" bundle="common"/>">
</form>
</body>
</html>