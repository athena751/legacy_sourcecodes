<!--
        Copyright (c) 2004-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: luncreatemiddle.jsp,v 1.3 2005/10/24 01:12:26 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.nashead.*
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*
                 ,com.nec.nsgui.taglib.nssorttab.*
                 ,java.util.*
                 ,java.lang.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<jsp:useBean id="luns" class="com.nec.sydney.beans.nashead.LunCreateBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = luns; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<%String src =  request.getParameter("src");%>
<%String url =  request.getParameter("nextURL");%>
<%String nextURL="";%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<script language="javaScript">
function initPage(){
    <%if (url!=null && !url.equals("")){//not from stoarge
        nextURL = "&nextURL="+url;
    }%>
    parent.frames[0].location="luncreatetop.jsp?src=<%=src+nextURL%>";
    parent.frames[2].location="luncreatebottom.jsp?src=<%=src+nextURL%>";
}

</script>
</head>
<body onload="displayAlert();initPage()" onResize="resize();">
<%if(!luns.isSuccess()){%>
<br><nsgui:message key="nas_nashead/storage/getddmapfaild"/>
<%}else{
    Vector lunList = luns.getLunList();
    if(lunList.size() == 0){%>
        <nsgui:message key="nas_nashead/luninit/noavaillun"/>
  <%}else{%>
        <table>
        <tr>
	    <td>
	    <nsgui:message key="nas_nashead/luninit/th_availlun"/>
	    </td>
	    <td><%=request.getAttribute("nashead_availlun")%></td>
	    </tr>
	    </table>
	    <br>
	    <%if(url!=null && !url.equals("")){%>
	        <form name="lunlist" method="post" target="_parent" action="../../../menu/common/forward.jsp">
	    <%}else{%>
	        <form name="lunlist" method="post" target="ACTION" action="../../../menu/common/forward.jsp">
	    <%}%>
	    <input type="hidden" name="nasHeadAvailableLun" value="<%=request.getAttribute("nashead_availlun")%>" />
	    <input type="hidden" name="beanClass" value="<%=luns.getClass().getName()%>" />
	    <input type="hidden" name="alertFlag" value="enable" />
	    <input type="hidden" name="operation" value="createLun"/>
	    <input type="hidden" name="src" value="<%=src%>" />
	    <input type="hidden" name="EXTEND_INACTIVE_INTERVAL" value="5000" />
	    <%if(url!=null && !url.equals("")){%>
	        <input type="hidden" name="nextURL" value="<%=request.getParameter("nextURL")%>" />
	    <%}%>
	    <%SortTableModel tableMode = new ListSTModel(lunList);%>
        <nssorttab:table  tablemodel="<%=(SortTableModel)tableMode%>" 
                      id="list1"
                      table="border=1" 
                      sortonload="storageName:ascend" >
                      
            <nssorttab:column name="checkbox" 
                              th="STHeaderRender" 
                              td="com.nec.sydney.beans.nashead.STDataRender4Nashead"
                              sortable="no">
            </nssorttab:column>
            
	        <nssorttab:column name="storageName" 
	                          th="STHeaderRender" 
	                          td="com.nec.sydney.beans.nashead.STDataRender4Nashead"
	                          sortable="no"
	                          sidesort="lun">
	           <nsgui:message key="nas_nashead/storage/storagename"/>
	        </nssorttab:column>
	        
	        <nssorttab:column name="wwnn" 
	                          th="STHeaderRender" 
	                          td="com.nec.sydney.beans.nashead.STDataRender4Nashead"
	                          sortable="no">
	           <nsgui:message key="nas_nashead/storage/wwnn"/>
	        </nssorttab:column>
             
            <nssorttab:column name="lun" 
                              th="STHeaderRender" 
                              td="com.nec.sydney.beans.nashead.STDataRender4Nashead"
                              comparator="NumberStringComparator"
                              sortable="no">
                <nsgui:message key="nas_nashead/gateway/th_lun"/>
            </nssorttab:column>
        </nssorttab:table>	    
</form>
  <%}%>
<%}%>
</body>
</html>