<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportRootBottom4nsview.jsp,v 1.1 2005/08/22 05:39:17 wangzf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.framework.*" %>                            
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
var loaded = 0;
function bottomFrameInit(){
    loaded = 1;
    if(parent.frames[0].loaded && parent.frames[0].document.forms[0].hasExportGroup){
        document.forms[0].btnDetail.disabled=0;
        document.forms[0].btnModify.disabled=0;
    }
}

function onDetail(){
    if( !isSubmitted() ){
        return false;
    }     

    parent.frames[0].document.forms[0].action="<%=response.encodeURL("exportrootmplist.jsp")%>";
    setSubmitted();
    parent.frames[0].document.forms[0].submit();
    return true;    
}

function onModify(){
    if( !isSubmitted() ){
        return false;
    }     

    parent.frames[0].document.forms[0].action="<%=response.encodeURL("exportrootmodify4nsview.jsp")%>";
    setSubmitted();
    parent.frames[0].document.forms[0].submit();
    return true;    
}
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body  onload="bottomFrameInit();">
<form method="post">
<input type="button" name="btnDetail" value="<nsgui:message key="common/button/resource/detail2"/>" onclick="return onDetail();" disabled >
<input type="button" name="btnModify" value="<nsgui:message key="nas_exportroot/exportroot/btn_modify4nsview"/>" onclick="return onModify();" disabled >
</form>
</body>
</html>