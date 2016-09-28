<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMCreateShow.jsp,v 1.2312 2008/05/30 02:53:01 liuyq Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,java.lang.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="org.apache.struts.Globals"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<jsp:useBean id="createShow" class="com.nec.sydney.beans.lvm.LVMCreateShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = createShow; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@include file="../../../menu/common/fornashead.jsp" %>
<%
    String lvtype = createShow.getLvtype();
    boolean is1node = createShow.getIs1Node();
    String volumeBundle = Globals.MESSAGES_KEY + "/volume";
%>
<html>
<head>
<title>Create Logical Volume</title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="javaScript">
var selectedLdPath;
var wwnn;
var usedStorage;
var usedLdList;

function onSubmit(lvtype,is1node) {
    if (check(document.forms[0].name.value)==false) {
        alert("<nsgui:message key="common/alert/failed"/>"
                + "\r\n"
                + "<nsgui:message key="nas_lvm/alert/name"/>");
        return false;
    }

    if (selectedLdPath.value == "") {
        alert("<nsgui:message key="common/alert/failed"/>"
                + "\r\n"
                + "<nsgui:message key='<%="nas_lvm/alert/choose" + forNashead%>'/>");
        return false;
    }
    var selectedLunSize = document.getElementById("selectedLunSize").innerHTML;
    selectedLunSize = combinateStr(selectedLunSize);
    var maxSize=<%=VolumeActionConst.VOLUME_MAX_SIZE%>;
    var alertMsg="<bean:message key="msg.exceedMaxSize" bundle="<%=volumeBundle%>" />";

    if(parseFloat(selectedLunSize) > maxSize) { // The unit here is G. The max size of one lv is 130TB.
        alert("<nsgui:message key="common/alert/failed"/>"
                + "\r\n"
                + alertMsg);
        return false;        
    }
    
    <% if(isNasHead.booleanValue()){ %>
	    var radio_striping = document.getElementById("striping");
	    var radio_striping_checked = radio_striping && !radio_striping.disabled && radio_striping.checked;
	    if(radio_striping_checked){
		    if (window.differentSize.value == "1"){
		        alert("<nsgui:message key="common/alert/failed"/>"
                      + "\r\n"
                      + "<nsgui:message key="nas_lvm/alert/striping_create_size"/>");
		        return false;
		    }
	    }
    <%}%>

    if (lvtype=="cluster" && is1node=="false") {
        var node;
        if (document.forms[0].activeNode[0].checked) {
            node="<nsgui:message key="nas_lvm/common/node0"/>";
        } else {
            node="<nsgui:message key="nas_lvm/common/node1"/>";
        }
        if (isSubmitted()
            &&confirm("<nsgui:message key="common/confirm"/>"
                        + "\r\n"
                        + "<nsgui:message key="common/confirm/act"/>"
                        + "<nsgui:message key="common/button/resource/create"/>"
                        + "\r\n"
                        +"<nsgui:message key="nas_lvm/LVMCreateShow/lvm_name"/>"
                        + " : " + "<nsgui:message key="nas_lvm/LVMCreateShow/lvm_prefix"/>"
                        + document.forms[0].name.value
                        + "\r\n"
                        +"<nsgui:message key="nas_lvm/LVMCreateShow/th_node"/>"
                        + " : " + node)) {
            setSubmitted();
            lockMenu();
            document.lvmform.submit();
            disableButtonAll();
            return false;
        }
        return false;
    } else {
        if (isSubmitted()
            &&confirm("<nsgui:message key="common/confirm"/>"
                        + "\r\n"
                        + "<nsgui:message key="common/confirm/act"/>"
                        + "<nsgui:message key="common/button/resource/create"/>"
                        + "\r\n"
                        +"<nsgui:message key="nas_lvm/LVMCreateShow/lvm_name"/>"
                        + " : " + "<nsgui:message key="nas_lvm/LVMCreateShow/lvm_prefix"/>"
                        + document.forms[0].name.value
                        + "\r\n"
                        )) {
            setSubmitted();
            document.lvmform.submit();
            lockMenu();
            disableButtonAll();
            return false;
        }
        return false;
    }
}

function onCancel(lvtype) {
    if(lvtype=="cluster") {
        window.location="<%=response.encodeURL("LVMList.jsp")%>?cluster=true";
    } else {
       window.location="<%=response.encodeURL("LVMList.jsp")%>?cluster=false";
    }
    lockMenu();
    disableButtonAll();
}

var ldLunSelectHandler;
<% if(isNasHead.booleanValue()){ %>
function selectLun(){
    if (!isSubmitted()){
       return false;
    }
    if(ldLunSelectHandler==null || ldLunSelectHandler.closed){
        ldLunSelectHandler=window.open("/nsadmin/framework/moduleForward.do?h1=apply.recover.lvm&msgKey=apply.volume.volume.forward.to.lun.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/lunSelectShow.do?src=lvm","nasheadPop","toolbar=no,menubar=no,scrollbars=yes,width=500,height=520,resizable=yes");
    }else{
        ldLunSelectHandler.focus();
    }   
}
<%}else{%>
function selectLd(){
    if (!isSubmitted()){
       return false;
    }
    if(ldLunSelectHandler==null || ldLunSelectHandler.closed){
        ldLunSelectHandler=window.open("/nsadmin/framework/moduleForward.do?h1=apply.recover.lvm&msgKey=apply.volume.volume.forward.to.ld.choose&doNotLock=yes&doNotClear=yes&url=/nsadmin/volume/ldSelectShow.do?src=lvm","nasheadPop","toolbar=no,menubar=no,scrollbars=yes,width=500,height=520,resizable=yes");
    }else{
        ldLunSelectHandler.focus();
    }   
}
<%}%>
function check(str) {
    if (str == "")
        return false;
    var avail = /[^A-Za-z0-9_-]/g;
    ifFind = str.search(avail);
    return(ifFind==-1);
}

function closePopupWin(win){
    if (win != null && !win.closed){
        win.close();
    }
}
function init(){
    window.differentSize = document.forms[0].differentSize;
    window.selectedLdPath = document.forms[0].selectedLdPath;
    window.wwnn = document.forms[0].wwnn;
    <% if(isNasHead.booleanValue()){ %>
    window.gfsLicense = "<%=request.getAttribute("hasGfsLicense")%>";
    window.stripingRdo = document.getElementById("striping");
    window.notStripingRdo = document.getElementById("notStriping");
    <%}%>
}
</script>
<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" />
</head>
<BODY onload="displayAlert();init();" onUnload="unLockMenu();closePopupWin(ldLunSelectHandler);" onResize="resize()">

<h1 class="title"><nsgui:message key="nas_lvm/common/h1_lvm"/></h1>
<form name="lvmform" action="<%= response.encodeURL("lvmclustercreate.jsp") %>" method="post" onSubmit="return false;">
<input type="button" name="Cancel" value="<nsgui:message key="common/button/back"/>" onClick="onCancel('<%=lvtype%>')">

  <input type="hidden" name="differentSize" value="0">

<h2 class="title"><nsgui:message key="nas_lvm/lvmlist/msg_Create"/></h2>
<%
    if (lvtype.equals("cluster") && !is1node) {
        String node0Default = "";
        String node1Default = "";
        String defaultValue = request.getParameter("defaultNode");
        if (defaultValue.equals("0")) {
            node0Default = "checked";
        } else if (defaultValue.equals("1")) {
            node1Default = "checked";
        } else {
            node0Default = "checked";
        }
%>
<table border="1">
   <tr>
      <th align="left" valign="top" rowspan="2"><nsgui:message key="nas_lvm/LVMCreateShow/th_node"/></th>
      <td nowrap><input type="radio" name="activeNode" id="activeNodeID1" value="0" <%=node0Default%>><label for="activeNodeID1"><nsgui:message key="nas_lvm/common/node0"/></label></td>
   </tr>
   <tr>
      <td nowrap><input type="radio" name="activeNode" id="activeNodeID2" value="1" <%=node1Default%>><label for="activeNodeID2"><nsgui:message key="nas_lvm/common/node1"/></label></td>
   </tr>
</table>
<br>
<%
    }
%>
  <input type="hidden" name="type" value="<%=lvtype%>">

   <table name ="lvCreateTable" border="1">
    <tr>
      <th align="left"><nsgui:message key="nas_lvm/lvmlist/td_Name"/></th>
      <td colspan="2">
        <label><nsgui:message key="nas_lvm/LVMCreateShow/lvm_prefix"/></label>
        <input type="text" name="name" value="" maxlength="16">
      </td>
    </tr>
      <% if(isNasHead.booleanValue()){ %>
        <tr>
          <th valign="top" nowrap align="left"><nsgui:message key="nas_lvm/LVMCreateShow/select_lun"/></th>
          <td width="330px">
              <DIV id="selectedLun" style="overflow: auto; width: auto; height: auto;">--</DIV>
              <input type="hidden" name="selectedLdPath" value=""/>
              <input type="hidden" name="wwnn" value=""/>
          </td>
          <td valign="top" align="right"><input type="button" name="selectLunBtn" value="<nsgui:message key="nas_lvm/LVMCreateShow/btn_select_lun"/>" onClick="selectLun()"></td>
        </tr>
      <%}else{%>
        <tr>
          <th valign="top" nowrap align="left"><nsgui:message key="nas_lvm/LVMCreateShow/select_ld"/></th>
          <td width="230px">
              <DIV id="selectedLun" style="overflow: auto; width: auto; height: auto;">--</DIV>
              <input type="hidden" name="selectedLdPath" value=""/>
              <input type="hidden" name="wwnn" value=""/>
          </td>
          <td valign="top" align="right"><input type="button" name="selectLdBtn" value="<nsgui:message key="nas_lvm/LVMCreateShow/btn_select_ld"/>" onClick="selectLd()"></td>
        </tr>
      <%}%>
      
      <tr>
          <th align="left"><nsgui:message key="nas_lvm/lvmlist/td_Size"/></th>
          <td colspan=2><DIV id="selectedLunSize">--</DIV></td>
      </tr>  
      <% if(isNasHead.booleanValue()){ %>
      <logic:equal name="hasGfsLicense" value="true" scope="request">
      <tr>
          <th align="left"><nsgui:message key="nas_lvm/LVMCreateShow/option"/></th>
          <td colspan="2">
              <input type="radio" name="striping" id="striping" value="true" disabled>
              <label for="striping"><nsgui:message key="nas_lvm/LVMCreateShow/striping"/></label>
              &nbsp;&nbsp;
              <input type="radio" name="striping" id="notStriping" value="false" disabled checked>
              <label for="notStriping"><nsgui:message key="nas_lvm/LVMCreateShow/not_striping"/></label>
          </td>
      </tr>
      </logic:equal>
      <%}%>
  </table>

 <hr>
    <input type="button" name="Create" value="<nsgui:message key="common/button/submit"/>" onclick="onSubmit('<%=lvtype%>','<%=is1node?"true":"false"%>')">
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="hidden" name="alertFlag" value="enable">
</form>
</body>
</html>
