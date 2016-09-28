<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: snapShow.jsp,v 1.2307 2008/05/28 05:10:12 liy Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.snapshot.SnapShowBean
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.snapshot.SnapInfo
                    ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="snapshotBean" class="com.nec.sydney.beans.snapshot.SnapShowBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean =snapshotBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<script language="JavaScript">
    function setAct(value){
        document.snapForm.act.value = value;
    }


    function onVolumeList(){
    	lockMenu();
        window.location= "<%=snapshotBean.getMountPointListURL()%>";
    }
    function onSetSchedule(){
        //window.location="snapSchedule.jsp";
        window.location="<%=snapshotBean.getSnapScheduleURL()%>";
    }

    function isSpecialName(snapName){
        var specialName = new Array(new RegExp("^(com)[1-9]\\\.","i")
                                    ,new RegExp("^(com)[1-9]$","i")
                                    ,new RegExp("^(lpt)[1-9]\\\.","i")
                                    ,new RegExp("^(lpt)[1-9]$","i")
                                    ,new RegExp("^(aux)\\\.","i")
                                    ,new RegExp("^(aux)$","i")
                                    ,new RegExp("^(con)\\\.","i")
                                    ,new RegExp("^(con)$","i")
                                    ,new RegExp("^(nul)\\\.","i")
                                    ,new RegExp("^(nul)$","i")
                                    ,new RegExp("^(prn)\\\.","i")
                                    ,new RegExp("^(prn)$","i")
                                    ,new RegExp("^(.Snap)\\\.","i")
                                    ,new RegExp("^(.Snap)$","i")
                                    ,new RegExp("^(MVDCKPT_)","i")
                                    );
        for(var i=0; i<specialName.length;i++){
            if(snapName.search(specialName[i])!=-1){
                return true;
            }
        }
        return false;
    }

    function onCreateSnap()
    {
        //1. Validate the snapshot's name
        //If the name of snapshot
        //? Includes characters except for "a-z","A-Z","0-9",".","-", and "_"
        //Give out an alert and return false.
        if(<%=snapshotBean.getAvailableNumber()%> <= 0){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                   +"<nsgui:message key="nas_snapshot/alert/snapshot_num_invalid"/>");
            return false;
        }
        document.snapForm.snapName.value = trim(document.snapForm.snapName.value);
        var nameToAdd = document.snapForm.snapName.value;
        if(!isRightName(nameToAdd)
            || nameToAdd.match(/^\.+/)
            || nameToAdd.match(/\.+$/ ))
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                   +"<nsgui:message key="nas_snapshot/alert/invalidname"/>");
            return false;
        }
        if(isSpecialName(nameToAdd)){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                   +"<nsgui:message key="nas_snapshot/alert/contain_special_name"/>");
            return false;
        }
        for(var i=0;i<snapNameArray.length;i++){
            if(nameToAdd.toUpperCase()==snapNameArray[i].toUpperCase()){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                       +<nsgui:message key="nas_snapshot/alert/snapExist" firstReplace="nameToAdd" separate="true"/>);
                return false;
            }
        }
        if (isSubmitted()&&confirm ("<nsgui:message key="common/confirm"/>"+"\r\n"
                                                      +"<nsgui:message key="common/confirm/act"/>"+"<nsgui:message key="common/button/add"/>"+"\r\n"
                                                      +<nsgui:message key="nas_snapshot/alert/confirmsnap" firstReplace="nameToAdd" separate="true"/>))
        {
            setSubmitted();
            return true;
        }else
            return false;
    }
    function isRightChar(the_char)
    {
        var result = false;
        if(the_char=="."||the_char=="-"||the_char=="_"||the_char>="0"&&the_char<="9"||the_char>="a"&&the_char<="z"||the_char>="A"&&the_char<="Z")
        {
            result = true;
        }
        return result;
    }
    function isRightName(the_name)
    {
        var strLength = the_name.length;
        var result = true;
        if (strLength == 0)
        {
            return false;
        }
        for (var i=0; i<strLength; i++)
        {
            if(!isRightChar(the_name.charAt(i)))
            {
                result = false;
                break;
            }
        }
        //if the_name end with ".CR",return false
        if(the_name.match(/\.CR$/i))
        {
            result = false;
        }
        return result;
    }

    function onDeleteSnap()
    {
        if(document.snapForm.deleteSnapName.value == ""){
            alert("<nsgui:message key="nas_snapshot/alert/noCheckSnap"/>");
            return false;
        }
        if (document.snapForm.deleteSnapStatus.value != "active"){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                +"<nsgui:message key="nas_snapshot/alert/cannot_del"/>");
            return false;
        }
        if (isSubmitted()&&confirm("<nsgui:message key="common/confirm"/>"+"\r\n"
                                                     +"<nsgui:message key="common/confirm/act"/>"+"<nsgui:message key="common/button/delete"/>"+"\r\n"
                                                     +<nsgui:message key="nas_snapshot/alert/confirmdel" firstReplace="document.snapForm.deleteSnapName.value" separate="true"/>))
        {
            setSubmitted();
            document.snapForm.submit();
            return true;
        }else
            return false;
    }

    function setDeleteName(name, status){
        document.snapForm.deleteSnapStatus.value = status;
        document.snapForm.deleteSnapName.value = name;
    }
    
    function reloadPage(){
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();
        window.location="snapShow.jsp";
    }
</script>
<jsp:include page="../../common/wait.jsp" />
</HEAD>
<BODY onload="displayAlert();" onUnload="unLockMenu();">
 <h1 class="title"><nsgui:message key="nas_snapshot/common/h1"/></h1>
<form  method="post" name="snapForm" action="snapShowForward.jsp" onsubmit="setAct('createSnap');return onCreateSnap();" >
    <input type="button" name="volumeList" value="<nsgui:message key="common/button/back"/>" onclick="onVolumeList();" >
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
    <h2 class="title"><nsgui:message key="nas_snapshot/snapshow/h2_mp"/>[<%=snapshotBean.getMountPointName()%>]</h2>
    <h3 class="title"><nsgui:message key="nas_snapshot/snapshow/h3_schedule"/></h3>
    <input type="button" name="snapSchedule" value="<nsgui:message key="nas_snapshot/snapshow/button_edit"/>" onclick="onSetSchedule();">
    <hr>
    <h3 class="title"><nsgui:message key="nas_snapshot/snapshow/h3_create"/></h3>

    <table width="60%" border="1">
        <tr>
            <th>
                <nsgui:message key="nas_snapshot/snapshow/th_name"/>
            </th>
            <td>
                <input type="text" name="snapName" maxlength="31" size="42" value="">
            </td>
        </tr>
    </table><br>
    <input type="submit" name="formAct" value="<nsgui:message key="common/button/add"/>">
    <hr>
    <h3 class="title"><nsgui:message key="nas_snapshot/snapshow/h3_list"/></h3>

    <%
    Vector snapList = snapshotBean.getSnapList();
    int snapNumber = snapList.size();
    if(snapNumber==0)
    {
    %>
        <br><nsgui:message key="nas_snapshot/snapshow/msg_nosnap"/>
    <script language=JavaScript> snapNameArray=new Array(0); </script>
    <%
    }
    else
    {
        %>
        <table border="1">
            <tr>
                <th nowrap>&nbsp;</th>
                <th nowrap><nsgui:message key="nas_snapshot/snapshow/th_name"/></th>
                <th nowrap><nsgui:message key="nas_snapshot/snapshow/th_date"/></th>
                <th nowrap><nsgui:message key="nas_snapshot/snapshow/th_status"/></th>
            </tr>
        <script language=JavaScript> snapNameArray=new Array(<%=snapNumber%>); </script>
        <%
        SnapInfo snapInformation;
        String snapshotName;
        String statusValue;
        String statusText;
        String disabledFlg;
        for(int i=0;i<snapNumber;i++)
        {
            snapInformation = (SnapInfo)snapList.get(i);
            snapshotName = snapInformation.getName();
            statusValue = snapInformation.getStatus();
            if (statusValue.equalsIgnoreCase("active")){
                statusText = NSMessageDriver.getInstance().getMessage(session, 
                                "nas_snapshot/snapshow/status_active");
            }else if (statusValue.equalsIgnoreCase("removing")){
                statusText = NSMessageDriver.getInstance().getMessage(session, 
                                "nas_snapshot/snapshow/status_removing");
            }else if (statusValue.equalsIgnoreCase("hold")){
                statusText = NSMessageDriver.getInstance().getMessage(session, 
                                "nas_snapshot/snapshow/status_hold");
            }else{
                statusText = statusValue;
            }
            if (snapshotName.toUpperCase().startsWith("MVDCKPT_")) {
                disabledFlg = "disabled";
            } else {
                disabledFlg = "";
            }
            %>
            <tr>
                <td nowrap><input type="radio" name="SnapList" id="delete<%=i%>" value=""
                    onclick="setDeleteName('<%=snapshotName%>','<%=statusValue%>')" <%=disabledFlg%>>
                </td>
                <td nowrap><label for="delete<%=i%>"><%=snapshotName%></label></td>
                <td nowrap><%=snapInformation.getDate()%>&nbsp;&nbsp;<%=snapInformation.getTime()%></td>
                <td nowrap><%=statusText%></td>
            </tr>
            <script language=JavaScript> snapNameArray[<%=i%>]="<%=snapshotName%>"</script>
            <%
        }
        %>
        </table><br>
       <input type="button" name="formAct" value="<nsgui:message key="common/button/delete"/>"
        onclick="setAct('deleteSnap');return onDeleteSnap()">
        <%
    }
    %>
<br>
    <input type="hidden" name="act" value="">
    <input type="hidden" name="deleteSnapName" value="">
    <input type="hidden" name="deleteSnapStatus" value="">
    <input type="hidden" name="alertFlag" value="enable">
</form>
</BODY>
</HTML>
