<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originalmodifymid.jsp,v 1.2 2008/05/28 05:07:25 liy Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>   
<%@include file="replicationcommon.jsp" %>
<%@include file="originalcommon.jsp" %>  
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">


//============submit this form====invoked by btnframe===========================================================
function onSet(){
  	onSetModify();
}
function setScheduleDiv(convert){
	if(convert){
		if(convert.checked){
			document.getElementById("showCheckpoint").style.display="";
		}else{
			document.getElementById("showCheckpoint").style.display="none";
		}
	}else{
		document.getElementById("showCheckpoint").style.display="";
	}
}

</script>
</head>

<body onload="init('modify');setHelpAnchor('replication_3');setScheduleDiv(document.forms[0].convert);" onunload="unloadBtnFrame();closeDetailErrorWin();">
<html:form action="originalAction.do">
 
    <html:button property="goBack" onclick="return back2List();"> 
        <bean:message key="common.button.back" bundle="common"/>
    </html:button>
    <br>
    <displayerror:error h1_key="replicate.h1"/>
    <h3 class="title"><bean:message key="original.info.h3.modify"/></h3>
    <nested:nest property="originalInfo">
    <nested:equal property="repliMethod" value="<%=ReplicationActionConst.CONST_REPLI_METHOD_FULL%>">
		<html:checkbox property="convert" onclick="setScheduleDiv(this);" styleId="chk"/><label for="chk"><bean:message key="original.info.switch"/></label>
	</nested:equal>
	    <table border="1" nowrap class="Vertical">
            <tr>
                <th width="146px"><bean:message key="replication.info.filesetname"/></th>
                <td><html:hidden property="originalInfo.filesetName" write="true"/></td>                    
            </tr>   
            
		    <tr>
		        <th><bean:message key="replication.info.mountpoint" /></th>
		        <td><html:hidden  property="originalInfo.mountPoint" write="true"/></td>                
		    </tr>   
		     		    
            <%@include file="originalsetcommon.jsp" %>
		</table>
		 <nested:hidden property="repliMethod"/>
     </nested:nest>
     <input type="hidden" name="operation"/>
</html:form>
</body>
</html>


