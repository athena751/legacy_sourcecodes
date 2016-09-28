<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: navigatorbottom.jsp,v 1.3 2007/09/12 11:48:25 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>

<html:html lang="true">

<head>
<html:base/>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript" src="../common/validation.js"></script>
    <script language="JavaScript">
        var loaded=0;
        function submitCheck(){
            if(isSubmitted()){
                return false;
            }
            var source = document.forms[0].selectedSource.value;
            if(source==""){
                alert('<bean:message key="snmp.community.navigator.alert.noSourceSpecify" />');
                return false;
            }
            setSubmitted();
            if (top.opener &&top.opener.document.forms[1] &&top.opener.document.forms[1].sourcetext){
                top.opener.document.forms[1].sourcetext.value = source;
                top.opener.onChangeSource();
                top.close();
            } else {
                top.close();
            }
        }
        
       
    </script>
</head>

<body onLoad="loaded=1;">
    <form>
    <table>
        <tr><td>
            <input type="text" name="selectedSource" size="40" value=""
            readonly onfocus="this.blur();" >
        </td></tr>
        <tr><td>
            <input type="button" name="set" onclick="return submitCheck();" 
                    value='<bean:message key="common.button.submit" bundle="common"/>' >&nbsp;&nbsp;
            <input type="button" name="cancel" onclick="parent.close()"
                    value='<bean:message key="common.button.close" bundle="common"/>' >
        </td></tr>
    </table>
    </form>
</body>

</html:html>