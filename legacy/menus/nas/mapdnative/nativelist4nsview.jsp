<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nativelist4nsview.jsp,v 1.5 2007/12/06 04:39:49 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"%>

<%@ page import="java.util.*" %>
<%@ page import="com.nec.sydney.atom.admin.base.api.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.sydney.atom.admin.nfs.*" %>
<%@ page import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.beans.mapdnative.*" %>
<%@ page import="com.nec.sydney.atom.admin.mapd.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sort" prefix="sortTag" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>


<jsp:useBean id="listBean" class="com.nec.sydney.beans.mapdnative.NativeListBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = listBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>

<title><nsgui:message key="nas_native/common/title"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-JP">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<jsp:include page="../../common/wait.jsp"/>

<script src="../common/general.js"></script>

<%Vector unixVector = listBean.getUnixList();
Vector winVector = listBean.getNtList();%>
<script language="javascript">

    function onRedirect(url,type) {
        window.location=url + "?addType=" + type;
    }
    
   function reloadForSort(key,rev,id){
    var all_reverse="";
    var all_keyword="";
    if (document.forms.length){
        for (var i = 0;i<document.forms.length;i++) {
            if(document.forms[i].state_keyword && document.forms[i].state_keyword.length){
                for (var j=0;j<document.forms[i].state_keyword.length;j++){
                    all_reverse=all_reverse+"&state_reverse="+document.forms[i].state_reverse[j].value;
                    all_keyword=all_keyword+"&state_keyword="+document.forms[i].state_keyword[j].value;
                }
            }else {
    	        if(document.forms[i].state_keyword) {
    	            all_reverse=all_reverse+"&state_reverse="+document.forms[i].state_reverse.value;
    	            all_keyword=all_keyword+"&state_keyword="+document.forms[i].state_keyword.value;
    	        }
            }
        }
    }else {
        if(document.forms[0].state_keyword && document.forms[0].state_keyword.length){
            for (var j=0;j<document.forms[0].state_keyword.length;j++){
                all_reverse=all_reverse+"&state_reverse="+document.forms[0].state_reverse[j].value;
                all_keyword=all_keyword+"&state_keyword="+document.forms[0].state_keyword[j].value;
            }
        }else {
    	    if(document.forms[0].state_keyword) {
	        all_reverse=all_reverse+"&state_reverse="+document.forms[0].state_reverse.value;
	        all_keyword=all_keyword+"&state_keyword="+document.forms[0].state_keyword.value;
	    }
        }
    }
    window.location = "nativelist4nsview.jsp?&sort_ID="+id+"&sort_keyword="+key+"&sort_reverse="+rev+all_reverse+all_keyword;
}
    function reload_this_page(){
	window.location="<%=response.encodeURL("nativelist4nsview.jsp")%>";
    }

</script>

</head>

<body onload="displayAlert();">

<h1><nsgui:message key="nas_native/common/h1"/></h1>

<html:button property="reload" onclick="reload_this_page()">
	<nsgui:message key="nas_ftp/ftp_info/reload"/>
</html:button>
<form name="listForm" method="post" action="<%= response.encodeURL("nativelistforward.jsp")%>">
<input type="hidden" name="type" value=""/>
<input type="hidden" name="region" value=""/>
<input type="hidden" name="network" value=""/>
<input type="hidden" name="domain" value=""/>
<input type="hidden" name="server" value=""/>
<input type="hidden" name="nasAction" value=""/>
<input type="hidden" name="netbios" value=""/>
<input type="hidden" name="alertFlag" value="enable"/>

<h2><nsgui:message key="nas_native/nativeList/h2"/></h2>

<h3><nsgui:message key="nas_native/nativeList/h3_UnixList"/></h3>
<% 
    MPAndAuth domainInfo; 
    Hashtable nativeTable = listBean.getNativeTable();
    String checked="";
%>

    <%
    
    if(unixVector.size() <= 0 ) {%>
        <p>&nbsp;&nbsp;<nsgui:message key="nas_native/alert/no_unixDomain"/></p>
    <%} else {
        Vector unixNames = new Vector();
        Vector unixValues = new Vector();
        unixValues.add(NSMessageDriver.getInstance().getMessage(session, "nas_native/nativeList/th_addr"));
        unixValues.add(NSMessageDriver.getInstance().getMessage(session, "nas_mapd/unix/th_domaintype"));
        unixValues.add(NSMessageDriver.getInstance().getMessage(session, "nas_mapd/unix/th_resource"));
        unixNames.add("network String");
        unixNames.add("domainType String");
        unixNames.add(null);
        String defaultSortUnix = "network";
        String reverseUnix = "ascend";
        String sortTargetUnix = "reloadForSort";
    %>
        <table border="1">
            <tr>
               <sortTag:sort list="<%=unixVector%>" name="<%=unixNames%>" value="<%=unixValues%>" 
                    keyword="<%=defaultSortUnix%>" reverse="<%=reverseUnix%>" 
                    sortTarget="<%=sortTargetUnix%>" taglibID="0"/>
             </tr>
            <%for (int i=0; i < unixVector.size(); i++) { %>

                <tr>
                      <%domainInfo = (MPAndAuth)unixVector.get(i);
                        NativeDomain domainObj = (NativeDomain)nativeTable.get(domainInfo);
             	      %>
                  <td><%=domainInfo.getNetwork()%></td>
                  <td><%=domainInfo.getDomainType()%></td>
                  <td><%=domainInfo.getResource()%></td>
                </tr>
            <%} // end "for" %>
        </table>
        <br>
    <%} // end "else" %>
    
    
<p>
<h3><nsgui:message key="nas_native/nativeList/h3_winList"/></h3>
    <%
    
    if(winVector.size() <= 0 ) {%>
        <p>&nbsp;&nbsp;<nsgui:message key="nas_native/alert/no_winDomain"/></p>
    <%} else {
        Vector winNames = new Vector();
        Vector winValues = new Vector();
        winValues.add(NSMessageDriver.getInstance().getMessage(session, "nas_native/nativeList/domainbutton"));
        winValues.add(NSMessageDriver.getInstance().getMessage(session, "nas_mapd/unix/th_domaintype"));
        winValues.add(NSMessageDriver.getInstance().getMessage(session, "nas_mapd/unix/th_resource"));
        winNames.add("ntdomain String");
        winNames.add("domainType String");
        winNames.add(null);
        String defaultSortWin = "ntdomain";
        String reverseWin = "ascend";
        String sortTargetWin = "reloadForSort";
        String wchecked="";
    %>
        <table border="1">
            <tr>
               <sortTag:sort list="<%=winVector%>" name="<%=winNames%>" value="<%=winValues%>" 
                    keyword="<%=defaultSortWin%>" reverse="<%=reverseWin%>" 
                    sortTarget="<%=sortTargetWin%>" taglibID="1"/>
             </tr>
            <%for (int i=0; i < winVector.size(); i++) { %>
                <tr>
                      <%domainInfo = (MPAndAuth)winVector.get(i);
                        NativeDomain domainObj = (NativeDomain)nativeTable.get(domainInfo);
                       %>
                  <td><%=domainInfo.getNTDomain()%></td>
                  <td><%=domainInfo.getDomainType()%></td>
                  <td align="<%=domainInfo.getResource().equals(MPAndAuth.NONE)?"center":"left"%>">
                        <%=domainInfo.getResource()%>
                  </td>
                </tr>
            <%} // end "for" %>
        </table>
        <br>
    <%} // end "else" %>
    <br>
    

</form>
</body>
</html>
