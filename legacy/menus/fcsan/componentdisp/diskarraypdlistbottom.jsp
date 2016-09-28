<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraypdlistbottom.jsp,v 1.2301 2005/09/21 04:53:50 wangli Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 

<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<script language=javascript>
var win;
function detl(button)
{
    if(!button.disabled )
    {
        var diskid = parent.frames[1].document.forms[0].diskid.value;
        var pdid = parent.frames[1].document.forms[0].pdid.value;
        if(diskid!=""&&pdid!=""){
            win=window.open("<%=response.encodeURL("diskarraypddetail.jsp")%>?diskid="+diskid+"&pdid="+pdid,"detailpd", "scrollbars=yes,toolbar=no,menubar=no,resizable=yes,width=600,height=500")
            win.focus();
        }
    }
}

function checkradio()
{
    document.forms[0].detail.disabled = true;

    if(!parent.frames[1].document.forms[0]) {
        return;
    }

    if (parent.frames[1].document.forms[0].diskid&&parent.frames[1].document.forms[0].pdid)
    {
        document.forms[0].detail.disabled=false;
        return;
    }
}
</script>

<body onload="checkradio()">
<form>
    <input type=button  name="detail" value="<nsgui:message key="fcsan_common/button/button_detail"/>" onclick="detl(this)">
 
</form>
</body>
</html>