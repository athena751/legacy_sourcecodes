<!-- 
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldconstitutebottom.jsp,v 1.2303 2005/12/16 06:45:17 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*
                            ,com.nec.sydney.atom.admin.base.*
                            ,com.nec.sydney.framework.*,java.util.*
                            ,com.nec.sydney.beans.fcsan.common.*
                            ,com.nec.nsgui.action.base.NSActionUtil" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 

<%
String diskArrayID = request.getParameter("diskArrayID");
String diskname = request.getParameter("diskname");
boolean isNotNsview = !(NSActionUtil.isNsview(request));
%>
<html>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
function onBack()
{
    parent.location="<%=response.encodeURL("diskarrayconstituteshow.jsp")%>?diskid=<%=diskArrayID%>&diskname=<%=diskname%>";
}
var win;
function onDetail()
{
    if(!document.forms[0].detail.disabled)
    {
       var ldID=parent.frames[1].document.forms[0].ldID.value;
       win=window.open("<%=response.encodeURL("lddetail.jsp")%>?diskid=<%=diskArrayID%>&ldID="+ldID,"lddetail","scrollbars=yes,toolbar=no,menubar=no,resizable=yes,width=580,height=600");
       win.focus();
    }
}

function onRename()
{
    if(!document.forms[0].rename.disabled)
    {
        var ldID=parent.frames[1].document.forms[0].ldID.value;
        var ldName=parent.frames[1].document.forms[0].ldName.value;
        var ldType=parent.frames[1].document.forms[0].ldType.value;
        
        win=window.open("<%=response.encodeURL("ldtypeandnameshow.jsp")%>?diskArrayID=<%=diskArrayID%>&ldID="+ldID+"&ldName="+ldName+"&ldType="+ldType,"ldrename","scrollbars=yes,toolbar=no,menubar=no,width=480,height=250,resizable=yes");

        win.focus();
        
    }
}

function disableButton()
{
    document.forms[0].detail.disabled = true;
    <%if (isNotNsview){ %>
        document.forms[0].rename.disabled = true;
    <%}%>
    if(!parent.frames[1].document.forms[0]) {
        return;
    }
    if(!parent.frames[1].document.forms[0].radio){
        return;
    }

    <%if (isNotNsview){%>
    if ("<%=request.getParameter("monitorstate")%>" == "<%=FCSANConstants.FCSAN_STATE_RUNNING%>")
    {
        document.forms[0].rename.disabled=false;
        
    }
    <%}%>
    if(parent.frames[1].document.forms[0]&&parent.frames[1].document.forms[0].ldID)
    {
        document.forms[0].detail.disabled = false;    
    }
}

</script>
<body onLoad="disableButton()">
<form  method="post">
    <input type="button" name="detail" value="<nsgui:message key="fcsan_common/button/button_detail"/>" onClick="onDetail()" >
    <%if (isNotNsview){%>
        <input type="hidden" name="rename" value="<nsgui:message key="fcsan_componentdisp/ld/button_modifyname"/>" onClick="onRename()" >
    <%}%>
</form>
</body>
</html>
