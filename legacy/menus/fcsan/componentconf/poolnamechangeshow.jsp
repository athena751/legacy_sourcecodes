<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: poolnamechangeshow.jsp,v 1.3 2005/12/21 04:57:03 liyb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,java.lang.*,java.util.*,com.nec.sydney.framework.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="namechangshowBean" class="com.nec.sydney.beans.fcsan.componentconf.RankRebTimeChangeShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = namechangshowBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<title><nsgui:message key="fcsan_componentconf/poolnamechange/title_ct"/></title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<% String diskarrayname = request.getParameter("diskarrayname");
   String diskarrayid=request.getParameter("diskarrayid");
   String pdgroupnumber = request.getParameter("pdgroupnumber");
   Vector poolnumbers = namechangshowBean.getRanknumbers();
   DiskArrayRankInfo diskarraypoolinfo;
%>

<script language="JavaScript">

    var win;
 //validate pool name
    function isValidPoolName(poolname){
	    var invalidCharSet = /[^A-Za-z0-9\/_]/g;
	    if(poolname==""||poolname.search(invalidCharSet)!=-1){
	        return false;
	    }
	    return true;
    }
    
    function onOk() {
        if(document.forms[0].ok.disabled==true)
            return false;
        
        var tmptext = document.forms[0].poolnumber.options[document.forms[0].poolnumber.selectedIndex].text;
        var poololdname = tmptext.substring(0,tmptext.indexOf("("));
        var poolnewname = document.forms[0].newname.value;
  
        if(!isValidPoolName(poolnewname)){
           alert("<nsgui:message key="fcsan_componentconf/poolnamechange/namechange_failed_wrongname"/>");
           document.forms[0].newname.focus();
           return false;
        }
        
        var msg=<nsgui:message key="fcsan_componentconf/poolnamechange/msg_poolnamechangeconfirm" separate="true">
                      <nsgui:replacement value="poololdname"/>
                      <nsgui:replacement value="poolnewname"/>
                 </nsgui:message>;
        if(!confirm(msg)){ 
            return false;   
        } 
           
        document.forms[0].ok.disabled=true;
        document.forms[0].cancel.disabled=true;  
              
        win=window.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>"
                           +"?diskarrayname=<%=diskarrayname%>"
                           +"&diskarrayid=<%=diskarrayid%>"
                           +"&pdgroupnumber=<%=pdgroupnumber%>"
                           +"&poololdname="+poololdname
                           +"&poolnewname="+poolnewname
                           +"&target_jsp="+document.forms[0].target_jsp.value
                        ,"wndPoolNameChangeResult"
                        ,"toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=200");
        win.focus();
        return true;
    }
    
    function onCancel() {
        if(document.forms[0].cancel.disabled==true)
            return false;
        window.close()
    }
</script>
</head>

<body>
<form onsubmit="return false;">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/poolnamechange/h2_option"/></h2>
  <table border="0">
    <tr align="left" >
      <th align="left" nowrap><nsgui:message key="fcsan_componentconf/table/th_dan"/></th>
      <td>:</td>
      <td><%=diskarrayname%></td>
    </tr>
    <tr align="left" >
      <th align="left" nowrap><nsgui:message key="fcsan_componentconf/table/th_rn"/></th>
      <td>:</td>
      <td>
        <select name="poolnumber" >       
       
        <%for(int i=0;i<poolnumbers.size();i++){
       
          diskarraypoolinfo = (DiskArrayRankInfo)poolnumbers.get(i);%>
          <option <%=(i==0)?"selected":""%> value="<%=diskarraypoolinfo.getPoolName()%>"><%=diskarraypoolinfo.getPoolName()+"("+diskarraypoolinfo.getPoolNo()+")"%></option>
        <%}%>
        </select>
      </td>
    </tr>
    <tr>
	    <th align="left" nowrap>
	       <nsgui:message key="fcsan_componentconf/table/th_poolnewname"/> 
	    </th>
	    <td>:
	    </td>
	    <td>
	       <input type="text" name="newname" maxLength=32 size=48/>
	    </td>
    </tr>
    </table>
<br>
  <center> 
    <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onClick="onOk()"/>
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="onCancel()" />
    <input type="hidden" name="target_jsp" value="../componentconf/poolnamechange.jsp" />
  </center>
</form>
</body>
</html>
