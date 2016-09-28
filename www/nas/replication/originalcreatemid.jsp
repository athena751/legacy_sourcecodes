<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originalcreatemid.jsp,v 1.1 2005/09/15 05:57:57 liyb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head> 
<%@include file="/common/head.jsp" %>
<%@include file="replicationcommon.jsp" %> 
<%@include file="originalcommon.jsp" %> 
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">

 var volumeName = new Array(); 
 var fsType = new Array(); 
   
<logic:iterate id="mpBean" name="mpList" indexId="indexID">    
    volumeName[<%=indexID%>] ="<bean:write name="mpBean" property="volumeName"/>";
    fsType[<%=indexID%>] = "<bean:write name="mpBean" property="fsType"/>";
</logic:iterate>

//============submit this form====invoked by btnframe===========
function onSet(){    
   return(onSetAdd());  
}

</script>
</head>
  
  
<body onload="init('create');setHelpAnchor('replication_2');" onunload="unloadBtnFrame();closeDetailErrorWin();">
<html:form action="originalAction.do">
 
    <html:button property="goBack" onclick="return back2List();"> 
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
                    <bean:write name="exportgroup" />                
                    
                    <nested:select property="mountPoint" onchange="setVolumeFstype(this.selectedIndex)" >
                         <logic:notEmpty name="mpList" >
                              <html:optionsCollection name="mpList"  label="mountPointLast" value="mountPoint"/> 
                         </logic:notEmpty>
                         <logic:empty name="mpList" >
                               <html:option value="--------"> 
                                    <bean:message key="replication.info.novolume"/>
                               </html:option> 
                         </logic:empty>
                    </nested:select>  
                                          
                </td>
            </tr>    
            
            <tr>
                <th><bean:message key="replication.info.filesetname"/></th>
                <td>
                    <html:text property="filesetNamePrefix" size="20"  maxlength="250"/>
                    <bean:message key="replication.info.filesetseparator" /><SPAN ID="innerFilesetSuffix" ></SPAN>
                    <nested:hidden  property="filesetName" />
                    <html:hidden  property="filesetNameSuffix" />
               </td>
            </tr>   
            
            <%@include file="originalsetcommon.jsp" %> 
         </table>
      </nested:nest>
      <input type="hidden" name="operation"/>
      <html:hidden property="errorFrom" value="preCreate"/>
</html:form>
</body>
</html>


