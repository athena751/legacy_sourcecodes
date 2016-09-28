<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: configurationmenubottom.jsp,v 1.2305 2005/09/21 04:49:10 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.sydney.beans.fcsan.common.*" %>

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
</head>
<script>

function onrankspare(button)
{
    if(button.disabled)
        return;
    if(parent.frames[1].document.forms[0].diskarrayid.value!=""){          
        parent.location="<%=response.encodeURL("rankspare.jsp")%>?diskarrayid="+parent.frames[1].document.forms[0].diskarrayid.value+"&diskarrayname="+parent.frames[1].document.forms[0].diskarrayname.value+"&arraytype="+parent.frames[1].document.forms[0].arraytype.value;
    }
}

function checkradio()
{
    document.forms[0].rankspare.disabled = true;
    if (parent.frames[1].document.forms[0]
        &&parent.frames[1].document.forms[0].hassamename){        
        alert("<nsgui:message key="fcsan_common/specialmessage/same_name"/>");
        return;        
    }

    if(parent.frames[1].document.forms[0]
            &&parent.frames[1].document.forms[0].diskarrayid
            &&parent.frames[1].document.forms[0].diskarrayname
            &&parent.frames[1].document.forms[0].observation
            &&parent.frames[1].document.forms[0].arraytype) {
        if (parent.frames[1].document.forms[0].observation.value != "<%=FCSANConstants.FCSAN_STATE_NO_MONITORING%>") { 
            document.forms[0].rankspare.disabled=false;
           
            /*if diskarray is used by NAS, ldpurpose is disabled,
              else if it is used by iSCSI, the button is enabled.
              the exact usage are not sure, so this button is disabled now.
            */        
            var intType = parseInt(parent.frames[1].document.forms[0].arraytype.value,16);
            //if (intType < 0x50 || intType > 0x6f) {
            //    document.forms[0].rankspare.disabled=true;
            //} else {
                document.forms[0].rankspare.disabled=false;
            //}
        }
    }
}
</script>

<body onload="checkradio()">
<form>
    <input type="button" name="rankspare" value="<nsgui:message key="fcsan_componentconf/confmenu/button_rs"/>" onclick="onrankspare(this)">
</form>
</body>
</html>
