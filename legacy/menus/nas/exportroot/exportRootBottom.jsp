<!--
        Copyright (c) 2001-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportRootBottom.jsp,v 1.10 2009/01/12 10:23:24 xingyh Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst"%>                        
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
        document.forms[0].btnDelete.disabled=0;
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

    parent.frames[0].document.forms[0].action="<%=response.encodeURL("exportrootmodify.jsp")%>";
    setSubmitted();
    parent.frames[0].document.forms[0].submit();
    return true;    
}

function onDelete(){
    if( !isSubmitted() ){
        return false;
    }

    if(parent.frames[0].document.forms[0].mounted.value == "true"){
        alert(<nsgui:message key="nas_exportroot/alert/delexport_mount" 
                firstReplace="parent.frames[0].document.forms[0].exportgroup.value" separate="true"/>);
        return false;
    }
    var selectExport=parent.frames[0].document.forms[0].exportgroup.value;
    var strCurBusyExport = parent.frames[0].strCurBusyExport;
    if ( strCurBusyExport!="" ){
        var arrCurBusyExport = strCurBusyExport.split(",");
        for (var i = 0; i < arrCurBusyExport.length; i++){
            if ((selectExport == arrCurBusyExport[i])||("<%=NSActionConst.ERROR_GET_BUSY_EXPORT_GROUP%>"==arrCurBusyExport[i])){
                alert(<nsgui:message key="nas_exportroot/alert/delexport_mount" 
                        firstReplace="selectExport" separate="true"/>);
                return false;
            }
        }
    }    
    if(confirm("<nsgui:message key="common/confirm"/>" + "\r\n"
            +"<nsgui:message key="common/confirm/act"/>"+"<nsgui:message key="common/button/delete"/>"+"\r\n"
            +<nsgui:message key="nas_exportroot/alert/confrim_add" 
                    firstReplace="parent.frames[0].document.forms[0].exportgroup.value" separate="true"/>) ){
            parent.frames[0].document.forms[0].act.value = "delete";
            parent.frames[0].document.forms[0].action="<%=response.encodeURL("exportRootForward.jsp")%>";
            setSubmitted();
            parent.frames[0].document.forms[0].submit();
            return true;
     }
    return false;    
}
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body  onload="bottomFrameInit();">
<form method="post">
<input type="button" name="btnDetail" value="<nsgui:message key="common/button/resource/detail2"/>" onclick="return onDetail();"  onfocus="if(this.disabled) this.blur();" disabled >
<input type="button" name="btnModify" value="<nsgui:message key="common/button/modify2"/>" onclick="return onModify();"  onfocus="if(this.disabled) this.blur();" disabled >
&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="btnDelete" value="<nsgui:message key="common/button/delete"/>" onclick="return onDelete();" onfocus="if(this.disabled) this.blur();" disabled >
</form>
</body>
</html>