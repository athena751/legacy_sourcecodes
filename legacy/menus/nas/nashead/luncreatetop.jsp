<!--
        Copyright (c) 2004-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: luncreatetop.jsp,v 1.1 2004/11/22 02:00:44 caoyh Exp" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.framework.*
                 ,java.util.*
                 ,java.lang.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<script language="javaScript">
function initPage(){
    document.forms[0].selectAll.disabled = true;
    document.forms[0].unselectAll.disabled = true;
    if(parent.frames[1] 
       && parent.frames[1].document.forms[0]
       && parent.frames[1].document.forms[0].lun){
        document.forms[0].selectAll.disabled = false;
        document.forms[0].unselectAll.disabled = false;
    }
}
function selectAllLun(isChecked){
    if(!parent.frames[1] 
       ||!parent.frames[1].document.forms[0]
       ||!parent.frames[1].document.forms[0].lun){
       return;
    } 
    //when only one lun existed
    if(!parent.frames[1].document.forms[0].lun.length){
        parent.frames[1].document.forms[0].lun.checked = isChecked;
    }
    var size = parent.frames[1].document.forms[0].lun.length;
    for(var i=0; i<size; i++){
        parent.frames[1].document.forms[0].lun[i].checked = isChecked
    }
}

</script>
</head>
<body onload="initPage()" onResize="resize();">
<form>
<%String src=request.getParameter("src");//the source module came from%>
<%String url=request.getParameter("nextURL");//the nextURL %>
<%if (src.equals("volume")){%>
    <h1 class="popup"><nsgui:message key="nas_nashead/common/h1_volume"/></h1>
<%}else if (src.equals("lvm")){%>
    <h1 class="popup"><nsgui:message key="nas_nashead/new/h1_lvm"/></h1>
<%}else if (src.equals("replication")){%>
    <h1 class="popup"><nsgui:message key="nas_nashead/new/h1_replication"/></h1>
<%}else{ // from storage%>
    <h1 class="title"><nsgui:message key="nas_nashead/common/h1_storage"/></h1>
<%}%>

<%if (url!=null && !url.equals("")){%>
    <input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="parent.location='/nsadmin/volume/lunSelectShow.do?src=<%=src%>'" />
<%}else{ // from stoarge%>
    <input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="parent.location='<%=response.encodeURL("ldlist.jsp") %>'" />
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onClick="parent.location='luncreate.jsp?src=<%=src%>'" />
<%}%>
<%if(src.equals("link")){%>
<h2 class="title"><nsgui:message key="nas_nashead/common/h2_linklun"/></h2>
<%}else if(src.equals("init")){%>
<h2 class="title"><nsgui:message key="nas_nashead/common/h2_initlun"/></h2>
<%}else{%>
<h2 class="popup"><nsgui:message key="nas_nashead/common/h2_initlun"/></h2>
<%}%>
<table>
<tr>
<td>
<%
Boolean isNasHead = (Boolean) session.getAttribute(NSConstant.SESSION_ISNASHEAD);
if (isNasHead.booleanValue()){
    if(src.equals("link")){%>
    <nsgui:message key="nas_nashead/luninit/linktip"/>
    <%}else{%>
    <nsgui:message key="nas_nashead/luninit/inittip"/>
    <%}
}else{%>
    <%if(src.equals("link")){%>
        <nsgui:message key="nas_nashead/luninit/appliancelinktip"/>
    <%}else{%>
        <nsgui:message key="nas_nashead/luninit/applianceinittip"/>
    <%}
}%>
</td>
</tr>
</table>
<br>
<input type=button name="selectAll"  value="<nsgui:message key="nas_nashead/luninit/btn_selectAll"/>" onclick="selectAllLun(true)" />
<input type=button name="unselectAll" value="<nsgui:message key="nas_nashead/luninit/btn_unselectAll"/>" onclick="selectAllLun(false)" />
</form>
</body>
</html>