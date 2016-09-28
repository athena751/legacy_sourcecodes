<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: quotasettop.jsp,v 1.2310 2006/11/28 07:10:08 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.sydney.framework.*,com.nec.sydney.beans.quota.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="quotaBean" scope="page" class="com.nec.sydney.beans.quota.GetQuotaStatusBean"/>

<%AbstractJSPBean _abstractJSPBean = quotaBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>


<%
    String actionQuota = quotaBean.getQuotaStatus();
    
    String exportRoot = (String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT);
    String tmpMountPoint = (String)session.getAttribute(NasConstants.MP_SESSION_MOUNTPOINT);
    String filesystem = exportRoot+tmpMountPoint;
    String fsType = (String)session.getAttribute(NasSession.SESSION_QUOTA_FSTYPE);
    String checkQuota = request.getParameter("check");
    
    if(checkQuota==null || checkQuota.equals("")) {
        if(fsType.equals(NasConstants.FILETYPE_NT) ) {
            checkQuota = "yes";
        } else {
            checkQuota = "no";
        }
    }
    boolean isNsview = NSActionUtil.isNsview(request);
%>
<html>
<head>
<script src="../common/general.js"></script>
<jsp:include page="../../common/wait.jsp" />
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">

<script language="JavaScript">
function onUserReport()
{
   var type
   if(document.forms[0].IDToName.checked)
   {
       type="name"
   }else{
       type="id"
   }

/*  added by maojb on 2003.8.1 */
   var displayControl = "all";
   if (!document.forms[0].displayControl[0].disabled) {
        for (var i=0 ; i<document.forms[0].displayControl.length ; i++) {
            if (document.forms[0].displayControl[i].checked) {
                displayControl = document.forms[0].displayControl[i].value;
                break;
            }
        }
   }
   parent.bottomframe.location ="<%=response.encodeURL("userreport.jsp")%>?"+"type="+URLEncoder(type)+"&keyword=id&reverse=true&commandid=user&displayControl="+displayControl+"&unit="+document.forms[0].unit.options[document.forms[0].unit.selectedIndex].value; //added by maojb on 2003.8.1
}

function onGroupReport()
{
   var type
   if(document.forms[0].IDToName.checked)
   {
       type="name"
   }else{
       type="id"
   }

/*  added by maojb on 2003.8.1 */
   var displayControl = "all";
   if (!document.forms[0].displayControl[0].disabled) {
        for (var i=0 ; i<document.forms[0].displayControl.length ; i++) {
            if (document.forms[0].displayControl[i].checked) {
                displayControl = document.forms[0].displayControl[i].value;
                break;
            }
        }
   }
   parent.bottomframe.location="<%=response.encodeURL("groupreport.jsp")%>?"+"type="+URLEncoder(type)+"&keyword=id&reverse=true&commandid=group&displayControl="+displayControl+"&unit="+document.forms[0].unit.options[document.forms[0].unit.selectedIndex].value;  //added by maojb on 2003.8.1
}

function onQuotaSet()
{
    parent.bottomframe.location="<%=response.encodeURL("quotasetbottom.jsp")%>";
}

function onGraceTime()
{
   parent.bottomframe.location="<%=response.encodeURL("gracetime.jsp")%>";
}
<%if(isNsview){%>
function onStatus() {
    parent.bottomframe.location="<%=response.encodeURL("quotastatus.jsp")%>";
}
<%}%>
function changType()
{
    var msg = "<nsgui:message key="common/confirm" />" + "\r\n";
    
    <%
        
    if (actionQuota.equals(NasConstants.REPQUOTA_STATUS_ON))
    { %>
        msg = msg + "<nsgui:message key="common/confirm/act" />" 
               + "<nsgui:message key="nas_quota/quotasettop/button_stop"/>";
    <% } else { %>
        msg = msg + "<nsgui:message key="common/confirm/act" />" 
               + "<nsgui:message key="nas_quota/quotasettop/button_start"/>";
    <% } %>

    if(isSubmitted() && confirm(msg))
    {
        setSubmitted();
    <%
        
        if (actionQuota.equals(NasConstants.REPQUOTA_STATUS_ON))
        {
    %>

        window.location="<%=response.encodeURL("changequota.jsp")%>?action=<%=actionQuota%>&check="+URLEncoder(document.forms[0].IDToName.checked);
    <%
        }
    %>
    <%
        if (actionQuota.equals(NasConstants.REPQUOTA_STATUS_OFF))
        {
    %>
        
        window.location="<%=response.encodeURL("changequota.jsp")%>?action=<%=actionQuota%>&check="+URLEncoder(document.forms[0].IDToName.checked);
    <%
        }
    %>
    }
}


/* added by maojb on 2003.8.1 */

function doWithDisable(obj) {
    if (obj.disabled) {
        obj.checked=false;

        var OSinfo=navigator.appVersion;
        if(OSinfo.indexOf("Windows")==-1&&navigator.appName.indexOf("Netscape")>=0&&OSinfo.split(" ")[0]<6.0)
        {
            return false;
        }
        if(OSinfo.indexOf("Windows")>=0&&navigator.appName.indexOf("Netscape")>=0&&OSinfo.split(" ")[0]<6.0)
        {
            return true;
        }
    }
}

function decideRadio() {
    if (document.forms[0].IDToName) {
        if (document.forms[0].IDToName.checked) {
            for (var i=0 ; i<document.forms[0].displayControl.length ; i++) {
                document.forms[0].displayControl[i].disabled = false ;
            }
            document.forms[0].displayControl[0].checked = true;
        } else {
            for (var i=0 ; i<document.forms[0].displayControl.length ; i++) {
                document.forms[0].displayControl[i].disabled = true ;
                if (document.forms[0].displayControl[i].checked) {
                    doWithDisable(document.forms[0].displayControl[i]);
                }
            }
        }
    } 
}

function decideDefaulValue()
{
<%if(!isNsview){%>
    <%if(actionQuota.equals(NasConstants.REPQUOTA_STATUS_OFF)){%>
        document.forms[0].quotacase.value= "<nsgui:message key="nas_quota/quotasettop/button_start"/>";
    <%}%>
    <%if(actionQuota.equals(NasConstants.REPQUOTA_STATUS_ON)){%>
        document.forms[0].quotacase.value= "<nsgui:message key="nas_quota/quotasettop/button_stop"/>";
    <%}%>
<%}%>
    
    <%
        if(checkQuota.equals("yes"))
        {
    %>
        document.forms[0].IDToName.checked=true;
    <%
        }
    %>
    <%
        if(checkQuota.equals("no"))
        {
    %>
        document.forms[0].IDToName.checked=false;
    <%
        }
    %>

    decideRadio();
    <%if(isNsview){%>
        onUserReport();
    <%}%>
}
function backtop()
{
    parent.location="<%=response.encodeURL("../common/mountpoint.jsp?nextAction=quota&action=selected")%>";
}

function changeUnit(){
    if (parent.frames[1] && parent.frames[1].document.forms[0]){
        if (!parent.frames[1].document.forms[0].pageFlag){
            return true;
        }
        if (parent.frames[1].document.forms[0].pageFlag.value=="user"){
            return onUserReport();
        } else {
            return onGroupReport();
        }
    } else {
        return false;
    }
}
function onReload(){
    if (parent.frames[1] && parent.frames[1].document.forms[0]){
        if (!parent.frames[1].document.forms[0].pageFlag){
            <%if(!isNsview){%>
                onQuotaSet();
            <%}%>
            return true;
        }else {
            if (parent.frames[1].document.forms[0].pageFlag.value=="user"){
                onUserReport();
            }else if(parent.frames[1].document.forms[0].pageFlag.value=="group"){	
                onGroupReport();
            }else if(parent.frames[1].document.forms[0].pageFlag.value=="graceperiod"){
                onGraceTime();
            }
            return true;
        }
    }else{
        return false;
    }
}
</script>
</head>

<body topmargin="0" marginwidth="0" marginheight="0" onLoad="decideDefaulValue();displayAlert();">
<form method="post" action="">

<h1 class="title"><nsgui:message key="nas_quota/quotasettop/h1"/></h1>
<%if(isNsview){%>
    <input type="button" name="back" onClick="backtop()" 
            value="<nsgui:message key="common/button/back"/>">
    <input type="button" name="reload" onclick="onReload()" 
            value="<nsgui:message key="common/button/reload"/>">
<%}%>
<h2 class="title"><nsgui:message key="nas_quota/quotasettop/h2_filesystem"/>[<%=filesystem%>]</h2>
<%if(!isNsview){%>
    <input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="backtop()">
    <input type="button" name="reload" onclick="onReload()" 
            value="<nsgui:message key="common/button/reload"/>"><br>
<%}%>

<table>
  <tr>
    <td nowrap>
      <input type="button" name="userreport" value="<nsgui:message key="nas_quota/quotasettop/href_1"/>" onclick="onUserReport()">
    </td>
    <td nowrap>
      <input type="button" name="groupreport" value="<nsgui:message key="nas_quota/quotasettop/href_2"/>" onclick="onGroupReport()">
    </td>
    <td nowrap>
      <input type="checkbox" name="IDToName" ID="IDToNameID" onClick="decideRadio()"><label for="IDToNameID"><nsgui:message key="nas_quota/quotasettop/check_1"/></label>
    </td>
    <td>
      <select name="unit" onChange="changeUnit()">
        <option value="--" selected>--</option>
        <option value="k">k</option>
        <option value="M">M</option>
        <option value="G">G</option>
      </select>
      <nsgui:message key="nas_quota/quotasettop/unit"/>
    </td>
  </tr>
  <tr>
    <td nowrap>
      <input type="radio" name="displayControl" ID="radio1" value="all" disabled onClick="return doWithDisable(this)">
      <label for="radio1"><nsgui:message key="nas_quota/quotasettop/display_all"/></label>
    </td>
    <td nowrap>
      <input type="radio" name="displayControl" ID="radio2" value="except" disabled onClick="return doWithDisable(this)">
      <label for="radio2"><nsgui:message key="nas_quota/quotasettop/display_except"/></label>
    </td>
    <td nowrap>
      <input type="radio" name="displayControl" ID="radio3" value="only" disabled onClick="return doWithDisable(this)">
      <label for="radio3"><nsgui:message key="nas_quota/quotasettop/display_only"/></label>
    </td>
    <td>&nbsp;</td>
  </tr>
</table>
<br>
<table>
    <tr>
        <%if(!isNsview){%>
            <td>
                <input type="button" name="quotaset" value="<nsgui:message key="nas_quota/quotasettop/href_3"/>" onclick="onQuotaSet()">
            </td>
        <%}%>
        <td>
            <input type="button" name="gracetime" value="<nsgui:message key="nas_quota/quotasettop/href_4"/>" onclick="onGraceTime()">
        </td>
        <%if(!isNsview){%>
            <td>
                <input type="button" name="quotacase" value="<nsgui:message key="nas_quota/quotasettop/button_start"/>" onClick="changType()">
            </td>
        <%}%>
        <%if(isNsview){%>
            <td>
                <input type="button" name="quotastatus" value="<nsgui:message key="nas_quota/quotasettop/href_status"/>" onClick="onStatus()">
            </td>
        <%}%>
    </tr>
</table>

<input type="hidden" name="alertFlag" value="enable">
</form>
</body>
</html>
