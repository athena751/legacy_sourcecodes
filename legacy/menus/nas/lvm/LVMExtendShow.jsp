<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMExtendShow.jsp,v 1.2317 2008/05/30 02:53:13 liuyq Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.beans.base.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<jsp:useBean id="extendShow" class="com.nec.sydney.beans.lvm.LVMExtendShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = extendShow; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst,com.nec.nsgui.action.base.NSActionConst,org.apache.struts.Globals"%>

<%@include file="../../../menu/common/fornashead.jsp" %>

<%
String lvtype = request.getParameter("lvtype");
String node = request.getParameter("node");
String lvname=extendShow.getLvname();
String size=extendShow.getSize();
String mountPoint = extendShow.getMountPoint();
String volumeBundle = Globals.MESSAGES_KEY + "/volume";
%>

<html>
<head>
<title>Extend Logical Volume</title>
<link rel="stylesheet" href="<%=request.getContextPath()+NSActionConst.DEFAULT_CSS_FILE_NAME%>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="javascript">
var wwnn;
var usedStorage;
var usedLdList;
var selectedLdPath;

function confirmExtend(form) {
    
    if (selectedLdPath.value == "") {
        alert("<nsgui:message key="common/alert/failed"/>"
               + "\r\n"
               + "<nsgui:message key='<%="nas_lvm/alert/choose" + forNashead%>'/>");
        return false;
    }
    <% if(isNasHead.booleanValue()){ %>
    /// check lun size 's difference when extending striping lv
    var radio_striping = document.getElementById("striping");
    var radio_striping_checked = radio_striping && !radio_striping.disabled && radio_striping.checked;
    if(radio_striping_checked){
	    if(window.differentSize.value == "1"){
	        alert("<nsgui:message key="common/alert/failed"/>"
	        + "\r\n"
	        + "<nsgui:message key="nas_lvm/alert/striping_extend_size"/>");
	        return false;  
	    }
    }
    <%}%>
    var extendSize = document.getElementById("selectedLunSize").innerHTML;
    extendSize = combinateStr(extendSize);
    var sum_size = parseFloat("<%=size%>") + parseFloat(extendSize);

    var maxSize=<%=VolumeActionConst.VOLUME_MAX_SIZE%>;
    var alertMsg="<bean:message key="msg.exceedMaxSize" bundle="<%=volumeBundle%>" />";
    <% if (!mountPoint.equals("--")) { %>
        var hasSnapshot = "<%=request.getAttribute("hasSnapshot")%>";
        var hasReplication = "<%=request.getAttribute("hasReplication")%>";
        if (hasSnapshot == "yes" && hasReplication == "yes"){
            maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
            alertMsg = "<bean:message key="msg.exceed20TB.snapshotMVDSync" bundle="<%=volumeBundle%>" />";
        }else if(hasSnapshot == "yes"){
            maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
            alertMsg = "<bean:message key="msg.exceed20TB.snapshot" bundle="<%=volumeBundle%>" />";  
        }else if(hasReplication == "yes"){
            maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
            alertMsg = "<bean:message key="msg.exceed20TB.MVDSync" bundle="<%=volumeBundle%>" />"; 
        }
    <%}%>

    if(sum_size > maxSize) { // The unit here is G. The max size of one lv is 128TB
        alert("<nsgui:message key="common/alert/failed"/>"
        + "\r\n"
        + alertMsg);
        return false;        
    }

    // add for volume license by jiangfx, 2007.7.5
    var licenseAlert = "";
    <% if (!mountPoint.equals("--")) { %>
	    <logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
	        // get license capacity and total created volume capacity
	        var licenseCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session"/>';
	        var totalFSCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session"/>';
	
	        // get cofirm message for exceed license capacity
	    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
	    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
	    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
	    	    && (parseFloat(extendSize) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
	    		licenseAlert = "<nsgui:message key="nas_lvm/lvmExtendShow/exceed_capLicense"/>" + "\r\n\r\n";
	    	}
	    </logic:equal>
    <%}%>

    var conmsg= licenseAlert + "<nsgui:message key="common/confirm"/>"
	             + "\r\n"
				 + "<nsgui:message key="common/confirm/act"/>"
				 + "<nsgui:message key="nas_lvm/common/submit_Extend"/>"
				 + "\r\n"
				 + "<nsgui:message key="nas_lvm/LVMCreateShow/target"/>"
				 + " : " + "<%=lvname%>";

    if (isSubmitted()&& confirm(conmsg))
    {
        document.forms[0].lvtype.value="<%=lvtype%>";
        setSubmitted();
        lockMenu(); 
        form.submit();       
        disableButtonAll();
        return false;
    }
    return false;
}

function cancel()
{
    if("<%=lvtype%>"=="cluster")
               window.location="<%=response.encodeURL("LVMList.jsp")%>?cluster=true";
    else
        window.location="<%=response.encodeURL("LVMList.jsp")%>?cluster=false";
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
function closePopupWin(win){
    if (win != null && !win.closed){
        win.close();
    }
}
function init(){
    window.differentSize = document.forms[0].differentSize;
    window.selectedLdPath = document.forms[0].selectedLdPath;
    window.wwnn = document.forms[0].wwnn;
    window.usedStorage = document.forms[0].usedStorage;
    window.usedLdList = document.forms[0].usedLdList;
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
<body onload="displayAlert();init();" onUnload="unLockMenu();closePopupWin(ldLunSelectHandler);">
<h1 class="title"><nsgui:message key="nas_lvm/common/h1_lvm"/></h1>
<form name="lvmform" method="post" action="<%=response.encodeURL("LVMExtend.jsp")%>?lvname=<%=lvname%>&node=<%=node%>" onsubmit="return false;">
 <input type="button" name="Submit2" value="<nsgui:message key="common/button/back"/>" onClick="cancel()">
<h2 class="title"><nsgui:message key="nas_lvm/lvmlist/th_Extend"/></h2>

<% if (!mountPoint.equals("--")) { %>
    <jsp:include page="../../../nas/volume/volumelicensecommon.jsp" flush="true">
        <jsp:param name="moduleBundle" value="<%=volumeBundle%>"/>
    </jsp:include>
<logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
    <br>
</logic:equal>
<%}%>

  <input type="hidden" name="differentSize" value="0">
  <input type="hidden" name="usedStorage" value="<%=extendShow.getLunStorageList()%>">
  <input type="hidden" name="usedLdList" value="<%=extendShow.getLdList()%>">
  <table border="1">
    <tr>
      <th align="left"><nsgui:message key="nas_lvm/lvmlist/td_Name"/></th>
      <td colspan="2"><%=lvname%> </td>
    </tr>
    <tr>
      <th align="left"><nsgui:message key="nas_lvm/lvmlist/td_Size"/></th>
      <td colspan="2"><%=(new DecimalFormat("#,##0.0")).format(new Double(size))%></td>
    </tr>

    <% if(isNasHead.booleanValue()){ %>
        <tr>
          <th valign="top"  align="left" nowrap><nsgui:message key="nas_lvm/LVMCreateShow/select_lun"/></th>
          <td width="330px">
              <%
                  String showStr = extendShow.getLunStorageList();
                  String divHeight = (showStr.split("<BR>").length >=3) ? "54px" : "auto";
              %>
              <DIV id="selectedLun" style="overflow: auto; width: auto; height: <%=divHeight%>;">
              <font color="#999999"><%=showStr%></font></DIV>
              <input type="hidden" name="selectedLdPath" value=""/>
              <input type="hidden" name="wwnn" value=""/>
          </td>
          <td valign="top" align="right"><input type="button" name="selectLunBtn" value="<nsgui:message key="nas_lvm/LVMCreateShow/btn_select_lun"/>" onClick="selectLun()"></td>
        </tr>
      <%}else{%>
        <tr>
          <th valign="top" align="left" nowrap><nsgui:message key="nas_lvm/LVMCreateShow/select_ld"/></th>
          <td>
              <%
                  String showStr = extendShow.getLdList();
                  String divHeight = (showStr.split("<BR>").length >=3) ? "54px" : "auto";
              %>
              <DIV id="selectedLun" style="overflow: auto; width: auto; height: <%=divHeight%>;">
              <font color="#999999"><%=showStr%></font></DIV>
              <input type="hidden" name="selectedLdPath" value=""/>
              <input type="hidden" name="wwnn" value=""/>
          </td>
          <td valign="top" align="right"><input type="button" name="selectLdBtn" value="<nsgui:message key="nas_lvm/LVMCreateShow/btn_select_ld"/>" onClick="selectLd()"></td>
        </tr>
    <%}%>
    <tr>
        <th align="left"><nsgui:message key="nas_lvm/LVMCreateShow/select_lun_size"/></th>
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
  <br>
<hr>
  <input type="button" name="button" value="<nsgui:message key="common/button/submit"/>" onclick="confirmExtend(lvmform)">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <input type="hidden" name="alertFlag" value="enable">
  <input type="hidden" name="lvtype" >
</form>
</body>
</html>
