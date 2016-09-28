<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: hostsInfoBottom.jsp,v 1.2 2007/05/29 09:21:59 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function onSubmit(nodeNumber){
    if (isSubmitted()){
        return false;
    }
    if(nodeNumber==0){
        if(!confirm('<bean:message key="common.confirm"         bundle="common"/>\r\n'+
                    '<bean:message key="common.confirm.action"  bundle="common"/>'+
                    '<bean:message key="common.button.recovery.node0" bundle="common"/>\r\n' +
                    '<bean:message key="hosts.alert.servicesrestart.warning"/>')){
            return false;
        }else{            
            document.forms[0].action="hostsInfoAction.do?Operation=applyNode0toNode1";                  
        }
    }else {
        if(!confirm('<bean:message key="common.confirm"         bundle="common"/>\r\n'+
                    '<bean:message key="common.confirm.action"  bundle="common"/>'+
                    '<bean:message key="common.button.recovery.node1" bundle="common"/>\r\n' +
                    '<bean:message key="hosts.alert.servicesrestart.warning"/>')){
            return false;
        }else{            
            document.forms[0].action="hostsInfoAction.do?Operation=applyNode1toNode0";                   
        }
    }    
    setSubmitted(); 
    document.forms[0].submit();
    return true;
}

function changeButtonStatus(){   
   if(parent.frames[0]){
       if(parent.frames[0].buttonEnable){
            document.forms[0].applyNode0.disabled = 0;
            document.forms[0].applyNode1.disabled = 0;
       }
    }
}

</script>
</head>
<body onload="changeButtonStatus();" style="margin: 10px;">
<form method="POST"  name="applyForm" target="_parent" >
    <input type="button" name="applyNode0" onclick="onSubmit(0)"
        value="<bean:message key="common.button.recovery.node0" bundle="common"/>" disabled /> 
    &nbsp;&nbsp;   
    <input type="button" name="applyNode1" onclick="onSubmit(1)"
        value="<bean:message key="common.button.recovery.node1" bundle="common"/>" disabled />
</form>
</body>
</html>
