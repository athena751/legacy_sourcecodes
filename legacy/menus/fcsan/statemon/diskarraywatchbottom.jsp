<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarraywatchbottom.jsp,v 1.2304 2008/04/19 15:36:47 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>

<html>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.sydney.beans.fcsan.common.*,com.nec.nsgui.action.base.NSActionUtil" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="diskarrayMonitor" class="com.nec.sydney.beans.fcsan.statemon.DiskArrayMonitorBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = diskarrayMonitor; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>


<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<head>
<!--title><nsgui:message key="fcsan_statemon/common/page_title"/></title-->
</head>
<script language=javascript>
var winstart;
var winstop;
function dostart(button)
{
    
    if(!button.disabled&&document.forms[0].diskid.value!="")
      {
        document.forms[0].behave.value="start";
        return true;
    }
    return false;
}

function dostop(button)
{
    if(!button.disabled&&document.forms[0].diskid.value!="")
    {
    <%if (NSActionUtil.hasActiveAsyncVolume(request)){%>
        alert("<nsgui:message key="fcsan_statemon/alert/exist_async_vol"/>");
        return false;
    <%}else if (NSActionUtil.hasActiveAsyncPair(request)){%>
        alert("<nsgui:message key="fcsan_statemon/alert/exist_async_pair"/>");
        return false;
    <%}else{%>
        document.forms[0].behave.value="stop";
        return true;
     <%}%>
    }
    return false;
}

function doInterrupt(button)
{
    if(!button.disabled&&document.forms[0].diskid.value!="")
    {
        document.forms[0].behave.value="fstop";
        return true;
    }
    return false;
}
function checkState(state)
{
    if (state.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_RUNNING%>")
    {
        document.forms[0].start.disabled=true;
        document.forms[0].stop.disabled=false;
        document.forms[0].interrupt.disabled=true;
    }else if (state.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_STOP%>")
    {
        document.forms[0].start.disabled=false;
        document.forms[0].stop.disabled=true;
        document.forms[0].interrupt.disabled=true;
    }else if (state.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_STOP_F%>")
    {
        document.forms[0].start.disabled=false;
        document.forms[0].stop.disabled=true;
        document.forms[0].interrupt.disabled=true;
    }else if (state.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_STOP_M%>")
    {
        document.forms[0].start.disabled=false;
        document.forms[0].stop.disabled=true;
        document.forms[0].interrupt.disabled=true;
    }else if (state.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_INIT%>")
    {
        document.forms[0].start.disabled=true;
        document.forms[0].stop.disabled=true;
        document.forms[0].interrupt.disabled=false;
    }else if (state.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_WAIT%>")
    {
        document.forms[0].start.disabled=true;
        document.forms[0].stop.disabled=true;
        document.forms[0].interrupt.disabled=false;
    }
    else{
        document.forms[0].start.disabled=true;
        document.forms[0].stop.disabled=true;
        document.forms[0].interrupt.disabled=true;
    }
}
function checkradio()
{
    document.forms[0].start.disabled=true;
    document.forms[0].stop.disabled=true;
    document.forms[0].interrupt.disabled=true;
    if (parent.frames[1].document.forms[0]
        &&parent.frames[1].document.forms[0].hassamename){
        alert("<nsgui:message key="fcsan_common/specialmessage/same_name"/>");
        return;
    }
  
    if (!parent.frames[1].document.forms[0])
    {
        return;
    }
    if (parent.frames[1].document.forms[0].diskid)
    {
        document.forms[0].diskid.value=parent.frames[1].document.forms[0].diskid.value;
        checkState(parent.frames[1].document.forms[0].observation.value);
    }
}
</script>

<body onload="checkradio();displayAlert();" >
<form name="watchBottomForm" method="post" action="<%= response.encodeURL("diskarraywatchcontrol.jsp")%>">
    <input type="submit" name="start"  disabled value="<nsgui:message key="fcsan_statemon/diskarraywatchbottom/submit_start"/>" onclick=" return dostart(this)">
    <input type="submit" name="stop" disabled  value="<nsgui:message key="fcsan_statemon/diskarraywatchbottom/submit_stop"/>" onclick=" return dostop(this)">
    <input type="submit" name="interrupt" disabled  value="<nsgui:message key="fcsan_statemon/diskarraywatchbottom/submit_interrupt"/>" onclick=" return doInterrupt(this)">
    <input type="hidden" name="diskid" value="">
    <input type="hidden" name="behave" value="">
    <input type="hidden" name="alertFlag" value="enable">
</form>
</body>
</html>
