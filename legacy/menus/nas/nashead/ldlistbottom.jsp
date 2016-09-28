<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldlistbottom.jsp,v 1.2 2008/04/19 15:18:36 jiangfx Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,java.lang.*" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.nashead.*
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*
                 ,java.util.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="javaScript">
var lun = new Array();
function onDelete(){
    if(!isSubmitted()){
        return false;
    } 
    var result=checkld();
    switch (result){
        case 1: //no lun has been select
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
              +"<nsgui:message key="nas_nashead/alert/nolunselect"/>");
        return false;
        
        case 2://select 0-15 ld
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +"<nsgui:message key="nas_nashead/alert/osusedld"/>");
        return false;
        
        case 3: //has been created into lvm
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +"<nsgui:message key="nas_nashead/alert/lvmusedlun"/>");
        return false;
        
        case 6: //has been paired
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +"<nsgui:message key="nas_nashead/alert/rvusedlun"/>");
        return false;
        
        case 4://can be destroied
        document.lunDestroy.operation.value = "delete";
        if(confirm("<nsgui:message key="common/confirm"/>"+ "\r\n"
                 + "<nsgui:message key="common/confirm/act"/>"
                 + "<nsgui:message key="nas_nashead/lun/lundelete"/>" + "\r\n"
                 +"<nsgui:message key="nas_nashead/lun/lunforconfirm"/>" +lun[0]+ "\r\n")){
            
            document.lunDestroy.wwnn.value=window.parent.midframe.document.luninfo.wwnn.value;
            document.lunDestroy.submit();
            setSubmitted();
            return true;
        }
        return false;
        
        default://upper frame has not loaded or other exception
        return false;
    }
}

function checkld(){
    if((window.parent.midframe)
        &&(window.parent.midframe.document)
        &&(window.parent.midframe.document.luninfo)
        &&(window.parent.midframe.document.luninfo.selectedLun)){
        
        var luninfo=window.parent.midframe.document.luninfo.selectedLun.value;
        if (luninfo=="") return 1;
        
        lun= luninfo.split(",");
        if (parseInt(lun[1].slice(7))<16) return 2;
        if (lun[2] == "y") return 3;
        if (lun[3] == "y") return 6;
        
        document.lunDestroy.selectedLun.value=lun[1];
        return 4;
    }else return 5;
    
}
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body>
<form name="lunDestroy" method="post" target="midframe" action="../../../menu/common/forward.jsp">
<input type="hidden" name="operation" value="">
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="beanClass" value="com.nec.sydney.beans.nashead.NasHeadListBean">
<input type="hidden" name="selectedLun" value="">
<input type="hidden" name="wwnn" value="">
<input type="button" name="delete" value="<nsgui:message key="nas_nashead/lun/lundelete"/>" onClick="onDelete();">
</form>
</body>
</html>
