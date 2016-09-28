<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: mountpoint.jsp,v 1.2312 2008/06/18 03:41:15 lil Exp $" -->


<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.beans.snapshot.MountPointBean
                            ,com.nec.sydney.beans.base.AbstractJSPBean
                            ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="mp" class="com.nec.sydney.beans.snapshot.MountPointBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = mp; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%
    boolean isNsview = NSActionUtil.isNsview(request);
%>
<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script src="../common/general.js"></script>
<script language=JavaScript>
    <%if( mp.needShowLimit() ){%>
        var oldLimit;
        var limitForm;
        function onSetLimit() {
            document.mpForm.cowLimit.value=limitForm.limitOption.options[limitForm.limitOption.selectedIndex].value;
            document.mpForm.cowLimit.value=parseInt(document.mpForm.cowLimit.value,10);
            if (document.mpForm.cowLimit.value !=0
                && document.mpForm.cowLimit.value < parseInt(cowUsedArray[document.mpForm.mountPoint.selectedIndex]) ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                       +"<nsgui:message key="nas_snapshot/alert/invalidlimitValue"/>");
                return false;
            }
            if (isSubmitted()&&confirm ("<nsgui:message key="common/confirm"/>"+"\r\n"
                                                          +"<nsgui:message key="common/confirm/act"/>"+"<nsgui:message key="common/button/modify"/>"
                                                          +"\r\n"+<nsgui:message key="nas_snapshot/alert/confirmlimit" firstReplace="document.mpForm.cowLimit.value" separate="true"/>))
            {
                setSubmitted();
                lockMenu();
                document.mpForm.act.value = "setLimit";
                document.mpForm.submit();
                return true;
            }else{
                return false;
            }
        }
    <%}%>
     function initialization() {
         <%if( mp.needShowLimit() ){%>
            if(document.getElementById){
                //Type 1: IE5,6; NN6;
                limitForm=document.getElementsByName("limitForm")[0];
            }

            if (document.layers){
                //Type 2: NN4
                limitForm=document.layers["limitLayer"].document.limitForm;
            }
         <%}%>
         <!-- the mountPoint array name os hexMountPointArray -->
         <%=mp.genMountPointArray()%>
         <%if( mp.needShowLimit() ){%>
            <%=mp.genCowUsedArray()%>
            <%=mp.genOldLimit()%>
            <%=mp.genType()%>
            mountPointChg(0);
            hideIt("limitLayer");
         <%}%>
     }

     function mountPointChg(num) {
         document.mpForm.hexMountPoint.value=hexMountPointArray[num];
         <%if( mp.needShowLimit() ){%>
            if(typeArray[num] == 'syncro'){
                document.getElementById("button_limit").disabled=true;
                hideIt("limitLayer");
                return;
            }else if(typeArray[num] == 'rw'){
                document.getElementById("button_limit").disabled=false;
            }
            <%if(isNsview){%>
                document.getElementById("usedArea").innerHTML = cowUsedArray[num] + "%";
                oldLimit = oldLimitArray[num];
                if(oldLimit == 9) {
                    document.getElementById("limitArea").innerHTML = "100%<nsgui:message key="nas_snapshot/snapshow/msg_unlimit"/>";
                } else {
                    document.getElementById("limitArea").innerHTML = (parseInt(oldLimit)+1)*10 + "%";
                }
            <% } else { %>
                limitForm.cowUsed.value=cowUsedArray[num];
                oldLimit = oldLimitArray[num];
                limitForm.limitOption.selectedIndex = 9 - oldLimit;                
            <% } %>
         <%}%>
     }

    function check(param) {
        if(!isSubmitted()){
            return false;
        }
        if(document.mpForm.mountPoint.options[param].value=="<%=NasConstants.MP_NULL_OPTION%>")
        {
            alert("<nsgui:message key="nas_common/alert/emptymp"/>");
            return false;
        }else{
            <% if (mp.getDestURL().equals(mp.MP_NEXT_ACTION_SNAPSHOT)) {%>
                <% if(isNsview) { %>
                    if(typeArray[param] == 'syncro'){
                        document.mpForm.action = "mountpointForward.jsp";
                    }
                <% } %>
                document.mpForm.type.value = typeArray[param];
            <% } %>
            document.mpForm.act.value = 'SELECT';
            setSubmitted();
            return true;
        }
    }

    function onLimit(param) {
         if(document.mpForm.mountPoint.options[param].value=="<%=NasConstants.MP_NULL_OPTION%>"){
            alert("<nsgui:message key="nas_common/alert/emptymp"/>");
            return false;
        }else{
            showIt("limitLayer");
        }
    }
    
    function reloadPage(){
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();
        lockMenu();
        window.location="<%= response.encodeURL("mountpoint.jsp?nextAction=" + mp.getDestURL())%>";
    }
    
    function displaySnapshotAlert(){
	    <%String snapshot_alertMSG = (String)request.getAttribute("SNAPSHOT_ALERT_MSG");
	      if(snapshot_alertMSG != null){%>
	          alert("<%=snapshot_alertMSG%>");	        
	    <%}%>
    }
       
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body onload="initialization();displayAlert();displaySnapshotAlert();" onUnload="unLockMenu();">
<% if (mp.getDestURL().equals(mp.MP_NEXT_ACTION_SNAPSHOT)) {%>
    <h1 class="title"><nsgui:message key="nas_common/mountpoint/h1_snapshot"/></h1>
<% }else if (mp.getDestURL().equals(NasConstants.MP_NEXT_ACTION_MAPD)){ %>
    <h1 class="title"><nsgui:message key="nas_common/mountpoint/h1_mapd"/></h1>
<% }else if (mp.getDestURL().equals(NasConstants.MP_NEXT_ACTION_QUOTA)) {%>
    <h1 class="title"><nsgui:message key="nas_common/mountpoint/h1_quota"/></h1>
        <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
        <br><br>
<% } %>

<% if(isNsview) {%>
     <% if (mp.getDestURL().equals(mp.MP_NEXT_ACTION_SNAPSHOT)) {%>
         <form name="mpForm" method="post" action="../snapshot/snapshot4nsview.jsp" >
    <% }else if(mp.getDestURL().equals(NasConstants.MP_NEXT_ACTION_QUOTA)) { %>
        <form name="mpForm" method="post" action="mountpointForward.jsp" >
    <% } %>
<% } else {%>
     <form name="mpForm" method="post" action="mountpointForward.jsp" >
<% }%>
    <input type="hidden" name="alertFlag" value="enable">
<% if (mp.getDestURL().equals(mp.MP_NEXT_ACTION_SNAPSHOT)) {%>
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
    <br><br>
<% }%>
<%  // the exportRoot is null
    if( !mp.getIsSelectedEgExist() ){%>
        <br><nsgui:message key="nas_common/mountpoint/msg_no_export_mp"/>
    <%}else{%>
        <input type="hidden" name="exportRoot" value="<%=mp.getSelectedExportRoot()%>" />
  <table border="1">
    <%String pageType = request.getParameter(mp.MP_NEXT_ACTION_PARAM);
    if( (pageType != null)
        && (!pageType.equalsIgnoreCase(mp.MP_NEXT_ACTION_SNAPSHOT))){%>
        <tr>
            <th><nsgui:message key="nas_common/mountpoint/th_action"/></th>
            <th><nsgui:message key="nas_common/mountpoint/th_mp"/></th>
        </tr>
        <tr>
            <td><center><input type="submit" name="selemp" value="<nsgui:message key="common/button/select"/>"
                 onClick="return check(document.mpForm.mountPoint.selectedIndex)">
            </center></td>
            <td>
            <center><select name="mountPoint" OnChange="mountPointChg(this.selectedIndex)">
                        <%=mp.getMountPointOptionHtml()%>
                    </select></center>
            </td>
        </tr>
    <%}else{%>
        <tr>
            <th><nsgui:message key="nas_common/mountpoint/th_mp"/></th>
            <td>
               <center>
               <select name="mountPoint" OnChange="mountPointChg(this.selectedIndex)">
                <%=mp.getMountPointOptionHtml()%>
               </select>
               </center>
            </td>
        </tr>
    <%}%>
    </table>
    <%if( (pageType != null)
        && (pageType.equalsIgnoreCase(mp.MP_NEXT_ACTION_SNAPSHOT))){%>
        <br><input type="submit" name="selemp" value="<nsgui:message key="common/button/select"/>"
             onClick="return check(document.mpForm.mountPoint.selectedIndex)">
        <%if(isNsview){%>
        <input type="button" id="button_limit" value="<nsgui:message key="nas_snapshot/snapshow/button_limit"/>"
             onclick="return onLimit(document.mpForm.mountPoint.selectedIndex)">
        <% } else {%>
        <input type="button" id="button_limit" value="<nsgui:message key="nas_common/mountpoint/button_limit"/>"
             onclick="return onLimit(document.mpForm.mountPoint.selectedIndex)">
        <% } %>
        <input type="hidden" name="cowLimit" value="">
        <input type="hidden" name="type" value=""/>
    <%}%>
<%}%>
        <input type="hidden" name="hexMountPoint" value="<%=mp.getSelectedHexMP()%>" >
       <input type="hidden" name="act" value="">
       <input type="hidden" name="<%=mp.MP_NEXT_ACTION_PARAM%>" value="<%=mp.getDestURL()%>" >
    </form>
    <%if( mp.needShowLimit() ){%>
        <div id="limitLayer" style="position:absolute;visibility:hidden">
        <form name="limitForm">
          <%if(isNsview) {%>
            <h2 class="title"><nsgui:message key="nas_snapshot/snapshow/h2_limit4nsview"/></h2>
          <%} else {%>            
            <h2 class="title"><nsgui:message key="nas_snapshot/snapshow/h2_limit"/></h2>
          <% } %>
            <table border="1">
                <tr>
                    <th align="left"><nsgui:message key="nas_snapshot/snapshow/th_used"/></th>
                    <td>
                      <%if(isNsview) {%>
                        <span id="usedArea"></span>
                      <%} else {%>
                        <input type="text" name="cowUsed" value="" onfocus="this.blur()" size="10" readonly>%
                      <%}%>
                    </td>
                </tr>
                <tr>
                    <th align="left"><nsgui:message key="nas_snapshot/snapshow/th_limit"/></th>
                    <td>
                      <%if(isNsview) {%>
                        <span id="limitArea"></span>
                      <%} else {%>
                        <select name="limitOption">
                            <option value="100" selected >100%<nsgui:message key="nas_snapshot/snapshow/msg_unlimit"/></option>
                            <option value="90">90%</option>
                            <option value="80">80%</option>
                            <option value="70">70%</option>
                            <option value="60">60%</option>
                            <option value="50">50%</option>
                            <option value="40">40%</option>
                            <option value="30">30%</option>
                            <option value="20">20%</option>
                            <option value="10">10%</option>
                        </select>
                      <% } %>
                    </td>
                </tr>
            </table>
            <!--When change the value of formAct,must not change the parameter of the setAct()-->
          <%if(!isNsview) {%>
            <br><input type="button" name="formAct" value="<nsgui:message key="common/button/submit"/>"
                     onclick="return onSetLimit()">
          <% } %>
        </form>
        </div>
    <%}%>
</body>
</html>
