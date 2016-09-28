<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originaltransfermid.jsp,v 1.1 2005/09/15 05:57:57 liyb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head> 
<%@include file="../../common/head.jsp" %> 
<%@include file="replicationcommon.jsp" %> 
<%@include file="originalcommon.jsp" %>   
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

//============submit this form====invoked by btnframe===========================================================
function onSet(){
   onSetAdd();  
}
</script>
</head>
<body onload="init('transfer');setHelpAnchor('replication_2');" onunload="unloadBtnFrame();closeDetailErrorWin();">
<html:form action="originalAction.do">
 
    <html:button disabled="true" property="goBack" > 
        <bean:message key="common.button.back" bundle="common"/>
    </html:button>
     <br>
     <br>
    <displayerror:error h1_key="replicate.h1"/>
    <h3 class="title"><bean:message key="original.info.h3.create"/></h3>
  
    <nested:nest property="originalInfo">  
        <table border="1" nowrap class="Vertical">
            <tr>
                <th><bean:message key="replication.info.mountpoint" /></th>
                <td>
                    <html:hidden property="originalInfo.mountPoint" write="true"/>                                          
                </td>
            </tr>    
            
               <tr>
                <th><bean:message key="replication.info.filesetname"/></th>
                <td>
                    <html:text property="filesetNamePrefix" size="20"  maxlength="250"/>
                    <bean:message key="replication.info.filesetseparator" /><html:hidden  property="filesetNameSuffix" write="true"/>  
                     <nested:hidden  property="filesetName" />                                    
                </td>
            </tr>   
            
            <%@include file="originalsetcommon.jsp" %> 
        
         </table>
      </nested:nest>
      <input type="hidden" name="operation"/>
      <html:hidden property="errorFrom" value="transfer"/>
</html:form>
</body>
</html>


