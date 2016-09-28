<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ranksparebottom.jsp,v 1.2309 2005/12/17 05:56:43 liq Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" %>
<%@ page import="com.nec.sydney.framework.*" %>
<script src="../../../menu/nas/common/general.js"></script>

<%
String diskarrayname=request.getParameter("diskarrayname");
String diskarrayid=request.getParameter("diskarrayid");
String arraytype=request.getParameter("arraytype");
String monitoringstate=request.getParameter("monitoringstate");
String pdgroupnumber=request.getParameter("pdgroupnumber");
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
function decideButton()
{
    var disableExpand1="true";
    var disableExpand2="true";
    var arraytype="<%=arraytype%>";
    // modified by caoyh on Sep. 5
    if("<%=monitoringstate%>"!="running" && "<%=monitoringstate%>"!="stop" || (arraytype >= "30h" && arraytype  <= "3fh"))  {
        return;
    }
    if (parent.frames[1].document.formofmiddleleft)  {
        if(parent.frames[1].document.forms[0].rankbind.value=="true")  {
            document.forms[0].rankbind.disabled=false;
        }
        if(parent.frames[1].document.forms[0].rankexpand1.value=="true")  {
            disableExpand1="false";
        }
        if(parent.frames[1].document.forms[0].sparebind.value=="true")  {
            document.forms[0].sparebind.disabled=false;
        }
        if(parent.frames[1].document.forms[0].spareunbind.value=="true")  {
            document.forms[0].spareunbind.disabled=false;
        }
    }
    if (parent.frames[2].document.formofmiddleright)   {        
        if(parent.frames[2].document.forms[0].rankunbind.value=="true")   {
            document.forms[0].rankunbind.disabled=false;
        }
        if(parent.frames[2].document.forms[0].rankexpand2.value=="true")   {
            disableExpand2="false";
        } 
        if(parent.frames[2].document.forms[0].rebuildingtimechange.value=="true")   {
            document.forms[0].rebuildingtimechange.disabled=false;
        }
        if(parent.frames[2].document.forms[0].poolnamechange.value=="true")   {
            document.forms[0].poolnamechange.disabled=false;
        }
    }
    if(disableExpand1=="false" && disableExpand2=="false")   {
        document.forms[0].rankexpand.disabled=false;
    }
}

function onRankbind()
{
    var pdgroupnumber;
    if(document.forms[0].rankbind.disabled)  {
        return;
    }    
    //pdgroupnumber=parent.frames[0].document.forms[0].pdgroup.options[parent.frames[0].document.forms[0].pdgroup.selectedIndex].value;
    pdgroupnumber = "<%=pdgroupnumber%>";
    var win = window.open("<%=response.encodeURL("/nsadmin/disk/bindpooldisplay.do")%>?from=disk&diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&pdgroupnumber="+pdgroupnumber,"winOfRankbind","toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=640,height=610");       
    win.focus();        
}


function onRankunbind()
{
    var pdgroupnumber;
    if(document.forms[0].rankunbind.disabled)  {
        return;
    }        
    //pdgroupnumber=parent.frames[0].document.forms[0].pdgroup.options[parent.frames[0].document.forms[0].pdgroup.selectedIndex].value;            
    pdgroupnumber = "<%=pdgroupnumber%>";
    var win = window.open("<%=response.encodeURL("rankunbind.jsp")%>?diskarrayname=<%=diskarrayname%>&diskarrayid=<%=diskarrayid%>&arraytype=<%=arraytype%>&pdgroupnumber="+pdgroupnumber,"winOfRankunbind","toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=400,height=240");        
    win.focus(); 
}

function onRankexpand()
{
    var pdgroupnumber;
    if(document.forms[0].rankexpand.disabled)   {
        return;
    }    
    //pdgroupnumber=parent.frames[0].document.forms[0].pdgroup.options[parent.frames[0].document.forms[0].pdgroup.selectedIndex].value; 
    pdgroupnumber = "<%=pdgroupnumber%>";   
    var win = window.open("<%=response.encodeURL("/nsadmin/disk/expandpooldisplay.do")%>?from=disk&diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&arraytype=<%=arraytype%>&pdgroupnumber="+pdgroupnumber,"winOfRankexpand","toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=640,height=610");       
    win.focus();        
}

function onRebuildingtimechange()
{
    var pdgroupnumber;
    if(document.forms[0].rebuildingtimechange.disabled)  {
        return;
    } 
    if(document.forms[0].poolnamechange.disabled)  {
        return;
    }
    //pdgroupnumber=parent.frames[0].document.forms[0].pdgroup.options[parent.frames[0].document.forms[0].pdgroup.selectedIndex].value;    
    pdgroupnumber = "<%=pdgroupnumber%>";
    var win = window.open("<%=response.encodeURL("rankrebuildingtimechangeshow.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber="+pdgroupnumber,"winOfRebuildingtimechange","toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=500,height=320");
    win.focus();        
}

//to open poolnamechangeshow.jsp
function onPoolNameChange()
{
   if(document.forms[0].poolnamechange.disabled)  {
        return;
    } 
   var pdgroupnumber = "<%=pdgroupnumber%>";   
   var win = window.open("<%=response.encodeURL("poolnamechangeshow.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber="+pdgroupnumber,"wndPoolNameChangeShow","toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=530,height=250");
   win.focus();        
}
function onSparebind()
{
    var pdgroupnumber;
    if(document.forms[0].sparebind.disabled)   {
        return;
    } 
    //pdgroupnumber=parent.frames[0].document.forms[0].pdgroup.options[parent.frames[0].document.forms[0].pdgroup.selectedIndex].value;    
    pdgroupnumber = "<%=pdgroupnumber%>";
    var    win = window.open("<%=response.encodeURL("sparebindshow.jsp")%>?diskarrayname=<%=diskarrayname%>&commandid=bind&pdgroupnumber="+pdgroupnumber,"winOfSparebind","toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=400,height=300");       
    win.focus();       
}

function onSpareunbind()
{
    var pdgroupnumber;
    if(document.forms[0].spareunbind.disabled)  {
        return;
    }    
    //pdgroupnumber=parent.frames[0].document.forms[0].pdgroup.options[parent.frames[0].document.forms[0].pdgroup.selectedIndex].value;    
    pdgroupnumber = "<%=pdgroupnumber%>";
    var win = window.open("<%=response.encodeURL("sparebindshow.jsp")%>?diskarrayname=<%=diskarrayname%>&commandid=unbind&pdgroupnumber="+pdgroupnumber,"winOfSpareunbind","toolbar=no,location=no,menubar=no,resizable=yes,scrollbars=yes,width=400,height=300");        
    win.focus();     
}

</script>
</head>
<body onLoad="decideButton()" onResize="resize()">
<form method="post">

<br>

<input type="button" name="rankbind" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_rankbind"/>" onClick="onRankbind()">
<input type="button" name="rankexpand" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_rankexpand"/>" onClick="onRankexpand()">
<input type="button" name="poolnamechange" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_poolnamechange"/>" onClick="onPoolNameChange()"/>
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" name="rankunbind" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_rankunbind"/>" onClick="onRankunbind()">
<br>

<input type="button" name="rebuildingtimechange" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_rebuildingtimechange"/>" onClick="onRebuildingtimechange()">

<br>

<input type="button" name="sparebind" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_sparebind"/>" onClick="onSparebind()">
<input type="button" name="spareunbind" value="<nsgui:message key="fcsan_componentconf/ranksparebottom/button_spareunbind"/>" onClick="onSpareunbind()">

</form>
</body>
</html>

<script language="javaScript">
document.forms[0].rankbind.disabled=true;
document.forms[0].rankunbind.disabled=true;
document.forms[0].sparebind.disabled=true;
document.forms[0].rankexpand.disabled=true;
document.forms[0].rebuildingtimechange.disabled=true;
document.forms[0].poolnamechange.disabled=true;
document.forms[0].spareunbind.disabled=true;
</script>