<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originaldemotemid.jsp,v 1.3 2008/05/28 05:07:25 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

    
<html>
<head>
<%@include file="../../common/head.jsp" %>
<%@include file="replicationcommon.jsp" %> 
<%@include file="originalcommon.jsp" %> 
<script language="JavaScript" src="../common/common.js">  </script>
<script language="JavaScript" >  
 
 //============submit this form====invoked by btnframe===========================================================
function onSet(){    
   return(onSetDemote());
}  
</script> 
</head>

<body onload="loadExecutePage();setHelpAnchor('replication_4');" onunload="unloadBtnFrame();closeDetailErrorWin();">
<html:form action="originalAction.do" >
        
    <html:button property="goBack" onclick="return back2List();;">
         <bean:message key="common.button.back" bundle="common"/>
    </html:button>
    
    <displayerror:error h1_key="replicate.h1"/>
    <h3 class="title"><bean:message key="original.info.h3.demote"/></h3>
   
    <br>
    <table border="1" nowrap class="Vertical">
      <tr>
         <td><bean:message key="original.info.demotecareful" /></td>
      </tr>
    </table>
    
    <br>
    
    <table border="1" nowrap class="Vertical">
      <tr>
         <th><bean:message key="replication.info.filesetname"/></th>         
         <td><html:hidden property="originalInfo.filesetName" write="true"/></td>
      </tr>
      
      <tr>
         <th><bean:message key="replication.info.mountpoint"/></th>
         <td><bean:write name="originalForm" property="originalInfo.mountPoint"/></td>
      </tr>
      
      <tr>
         <th><bean:message key="original.list.th.replicahost"/></th>
         
         <td>

          <logic:equal name="originalForm" property="originalInfo.replicaHost" value="localhost">
             <bean:message  key="original.info.nocontent"/>
          </logic:equal>
          <logic:notEqual name="originalForm" property="originalInfo.replicaHost" value="localhost">
             
             <logic:equal name="originalForm" property="originalInfo.replicaHost" value="all">
                 <bean:message  key="original.replicahost.permitall"/>
             </logic:equal>
             
             <logic:notEqual name="originalForm" property="originalInfo.replicaHost" value="all">
                  <bean:define id="trueHosts" name="originalForm" property="originalInfo.replicaHost" type="java.lang.String"/>
                  <%  String[] hosts = trueHosts.split(",");
      			      String rtnHost = "";
                      int len = hosts.length;
    			      for (int i = 0; i < len; i++) {
    				      if (!hosts[i].equals("localhost")) {
    					  rtnHost += " " + hosts[i];
    				      }
    			      }
    			      rtnHost = rtnHost.trim();   
    		      %>
    		      <%=rtnHost%> 
             </logic:notEqual>
             
          </logic:notEqual>
         </td>
      </tr>
    </table>
    <html:hidden property="originalInfo.mountPoint"/>
    <input type="hidden" name="operation"/>
</html:form>
</body>
</html>


