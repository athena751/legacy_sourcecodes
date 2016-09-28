<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: dirquotamountpoint.jsp,v 1.2312 2006/02/20 00:35:05 zhangjun Exp $" -->


<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.beans.snapshot.MountPointBean
                            ,com.nec.sydney.beans.base.AbstractJSPBean
                            ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="mp" class="com.nec.sydney.beans.snapshot.MountPointBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = mp; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%boolean isNsview = NSActionUtil.isNsview(request);%>

<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script src="../common/general.js"></script>
<script language=JavaScript>
     function initialization() {
        <!-- the mountPoint array name is hexMountPointArray -->
        <%=mp.genMountPointArray()%>
        <%if( !mp.getIsSelectedEgExist() ){%>
            var msgURL = "alertmessage.jsp?alertType=dirquota_noexp";
            parent.location = msgURL;
        <%}else{%>
            onDatasetList("no");
        <%}%>
        return true;
     }
     
     function doDisable(){
        <%if(!isNsview){%>
            document.forms[0].datasetadd.disabled=true;
            document.forms[0].datasetdel.disabled=true;
        <%}%>
        if((parent.frames[2].document.forms[0]) && (parent.frames[2].document.forms[0].dirquota)){
           parent.frames[2].document.forms[0].dirquota.disabled=true;
        }
    }
    
    function check(param) {
        doDisable();
        if(document.mpForm.mountPoint.options[param].value=="<%=NasConstants.MP_NULL_OPTION%>"){
            document.forms[0].datasetlist.disabled=true;
            document.mpForm.hexMountPoint.value="";
        }
        document.mpForm.act.value = 'SELECT';
        return true;
    }    
    
    function onDatasetList(isClick){
        var num = document.mpForm.mountPoint.selectedIndex;
        if(hexMountPointArray.length > num){
           document.mpForm.hexMountPoint.value=hexMountPointArray[num];
        }else{      
           document.mpForm.hexMountPoint.value=hexMountPointArray[0];
        }           
        if (isClick=="yes" && document.forms[0].datasetlist.disabled==true){
            return false;
        }   
        if (!isSubmitted() || 
            (isClick=="yes"&&(!parent.frames[1].loaded || parent.frames[1].loaded != 1))){
            return false;
        }  
        check(document.mpForm.mountPoint.selectedIndex);
        document.forms[0].nextDirQuotaAction.value='datasetlist';
        document.forms[0].action="forward.jsp";
        document.forms[0].target="middleframe";       
        document.forms[0].submit();
    }
    
    function onDatasetAdd(){
        if (document.forms[0].datasetadd.disabled==true){
            return false;
        }
        if (!isSubmitted()|| !parent.frames[1].loaded || parent.frames[1].loaded != 1){
            return false;
        }
        check(document.mpForm.mountPoint.selectedIndex);
        document.forms[0].nextDirQuotaAction.value='datasetadd';
        document.forms[0].action="dirquotaadd.jsp";
        document.forms[0].target="_parent";       
        document.forms[0].submit();
    }
    
    function onDatasetDelete(){
        if (document.forms[0].datasetdel.disabled==true){
            return false;
        }
        if (!isSubmitted()|| !parent.frames[1].loaded || parent.frames[1].loaded != 1){
            return false;
        }
        if(document.forms[0].dataset.value == ""){
            if (parent.frames[1].document.forms[0]  && parent.frames[1].document.forms[0].radiobutton){
                if (parent.frames[1].document.forms[0].radiobutton.length){
                    document.forms[0].dataset.value = parent.frames[1].document.forms[0].radiobutton[0].value;
                } else{
                    document.forms[0].dataset.value = parent.frames[1].document.forms[0].radiobutton.value;
                }
            }
        }
        
        if(document.forms[0].dataset.value==""){
            return false; 
        }
        if (confirm("<nsgui:message key="common/confirm"/>"+"\r\n"
                                      +"<nsgui:message key="common/confirm/act"/>"+"<nsgui:message key="nas_dataset/alert/delete"/>"))
                                      
        {   
            check(document.mpForm.mountPoint.selectedIndex);
            document.forms[0].action="datasetdestroy.jsp";
            document.forms[0].target="middleframe";       
            document.forms[0].submit();
        }else{
            return false;
        }
    }
   
    function onReload(){
        if (!isSubmitted()){
            return false;
        }
        setSubmitted();
        parent.location = "dirquotadatasetmain.jsp?nextAction=dirquota";
    }
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body onload="displayAlert();initialization()" onResize="resize()">
<h1 class="title"><nsgui:message key="nas_dataset/datasettop/dirquota"/></h1>


    <input type="button" name="reload" onclick="onReload()" 
        value="<nsgui:message key="common/button/reload"/>"><br>


<h2 class="title"><nsgui:message key="nas_dataset/datasettop/dataset"/></h2>
     <form name="mpForm" method="post" action="" >
<%  // the exportRootMap is null
   if( !mp.getIsSelectedEgExist() )
   {%>
        <br><nsgui:message key="nas_common/mountpoint/msg_no_export_mp"/>
   <%}
   else
   {%>
     <table border="1">
        <input type="hidden" name="exportRoot" value="<%=mp.getSelectedExportRoot()%>" />
        <tr>
            <th><nsgui:message key="nas_common/mountpoint/th_mp"/></th>
            <td align="left">
               <select name="mountPoint">
                <%=mp.getMountPointOptionHtml()%>
               </select>
            </td>
            <%if(isNsview){%>
                <td>
                    <input type="button" name="datasetlist" value="<nsgui:message key="common/button/select"/>" onClick="onDatasetList('yes')">
                </td>
            <%}%>
        </tr>
    </table>
    <br>
    <%if(!isNsview){%>
    <input type="button" name="datasetlist" value="<nsgui:message key="common/button/select"/>" onClick="onDatasetList('yes')">
    <input type="button" name="datasetadd" value="<nsgui:message key="nas_dataset/datasettop/datasetadd"/>" onClick="onDatasetAdd()">
    <input type="button" name="datasetdel" value="<nsgui:message key="nas_dataset/datasettop/datasetdel"/>" onClick="onDatasetDelete()">
    <%}%>
<%}%>
    <input type="hidden" name="hexMountPoint" value="<%=mp.getSelectedHexMP()%>" >
    <input type="hidden" name="dataset" value="" >
    <input type="hidden" name="selectedDataset" value="">
    <input type="hidden" name="act" value="">
    <input type="hidden" name="nextDirQuotaAction" value="">
    <input type="hidden" name="<%=mp.MP_NEXT_ACTION_PARAM%>" value="<%=mp.getDestURL()%>">
    </form>
</body>
</html>
