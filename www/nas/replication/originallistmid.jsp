<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originallistmid.jsp,v 1.5 2008/07/29 03:39:25 chenb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="com.nec.nsgui.taglib.nssorttab.ListSTModel" %>
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<html>
<head>
<%@include file="../../common/head.jsp" %> 
<%@include file="replicationcommon.jsp" %> 
<%@include file="originalcommon.jsp" %> 
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

//==========open botton frame===================================================   
function loadBtnframe()
{   
    if(parent.btnframe)
    {
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/toListBtm.do"/>' + '"',1);
    } 
  
}

//==============================
function preCreate()
{
	if (isSubmitted())
	{
	    return false;
	}
	 setSubmitted();
   
   
   window.location="/nsadmin/replication/originalAction.do?operation=preCreate";
}
//==============================
function onRadioClick(value)
{
    
   
    var tmp = value.split("$");

    document.forms[0].elements["originalInfo.filesetName"].value            = tmp[0];
    document.forms[0].elements["originalInfo.connectionAvailable"].value    = tmp[1];       
    document.forms[0].elements["originalInfo.transInterface"].value         = tmp[2];
    document.forms[0].elements["originalInfo.bandWidth"].value              = tmp[3];
    document.forms[0].elements["originalInfo.replicaHost"].value            = tmp[4];
    document.forms[0].elements["originalInfo.mountPoint"].value             = tmp[5];
    document.forms[0].elements["originalInfo.hasMounted"].value             = tmp[6];
    document.forms[0].elements["originalInfo.type"].value                   = tmp[7];
    document.forms[0].elements["originalInfo.volSyncInFileset"].value 				= tmp[8];
	document.forms[0].elements["originalInfo.hour"].value 					= tmp[9];
	document.forms[0].elements["originalInfo.minute"].value 					= tmp[10];
	document.forms[0].elements["originalInfo.repliMethod"].value 			= tmp[11];
    
    if(parent.btnframe &&parent.btnframe.document.forms[0])
    {
	    parent.btnframe.document.forms[0].modifyBtn.disabled=false;
	    parent.btnframe.document.forms[0].deleteBtn.disabled=false;
	    parent.btnframe.document.forms[0].demoteBtn.disabled=false;
	    
	    var originalType = tmp[7];
	    if(originalType != "export"){
	    	parent.btnframe.document.forms[0].demoteBtn.disabled=true;
	    }
	    
		if(tmp[8]==1){
			parent.btnframe.document.forms[0].modifyBtn.disabled = true;
			parent.btnframe.document.forms[0].deleteBtn.disabled = true;
			parent.btnframe.document.forms[0].demoteBtn.disabled = true;
    	}else if(tmp[8]== "<%=ReplicationActionConst.ERR_ORIGINAL_NOT_EXIST%>"){
    		parent.btnframe.document.forms[0].modifyBtn.disabled = true;
    		parent.btnframe.document.forms[0].demoteBtn.disabled = true;
    	}
	}     
}



//setType=preModify , preDemote or delete      
function onSet(setType)
{
  if(isSubmitted()){
     return;
  }
  if(document.forms[0].elements["originalInfo.hasMounted"].value !="yes"){
    alert("<bean:message key="replica.mountPoint.unmount"/>");
    return;
  }
  
  if (setType=="delete" && !confirm("<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
              + "<bean:message key="common.confirm.action" bundle="common"/>" 
              + "<bean:message key="common.button.delete" bundle="common"/>" )) {
     return;
   }
    setSubmitted();
    document.forms[0].operation.value=setType;

    document.forms[0].submit();
  }  


</script>
</head>

<body onload="loadBtnframe();setHelpAnchor('replication_1');" onunload="unloadBtnFrame();closeDetailErrorWin();">
<html:form action="originalAction.do" >
    <html:button property="reloadBtn" onclick="return back2List();">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>&nbsp;
   
    <html:button property="createBtn" onclick="preCreate();">
        <bean:message key="common.button.create2" bundle="common"/>
    </html:button>
    <br>
    <displayerror:error h1_key="replicate.h1"/>
    <br>
    <logic:empty name="oriList" scope="request">
        <bean:message key="original.info.nooriginal"/>
    </logic:empty> 
    
    <logic:notEmpty name="oriList" scope="request">
              
        <bean:define id="oriList" name="oriList" type="java.util.ArrayList"/>
        <nssorttab:table tablemodel="<%=new ListSTModel((java.util.ArrayList)oriList)%>" id="originalListTable" table="border=\"1\"" sortonload="filesetName">
            <nssorttab:column name="radioFset" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                                td="com.nec.nsgui.action.replication.STDataRender4Original"/>
                    
            <nssorttab:column name="filesetName" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="yes">
                    <bean:message key="replication.info.filesetname"/>
            </nssorttab:column>
            
            <nssorttab:column name="bandWidth" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message key="original.list.th.bandwidth"/>
            </nssorttab:column>
            
            <nssorttab:column name="transInterface" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message key="replication.info.interface"/>
            </nssorttab:column>
            
            
            <nssorttab:column name="connectionAvailable" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
                                            sortable="no">
                    <bean:message key="original.list.th.connection"/>
            </nssorttab:column>

            
            <nssorttab:column name="replicaHost" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message key="original.list.th.replicahost"/>
            </nssorttab:column>
            
            <nssorttab:column name="mountPoint" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                            sortable="yes">
                    <bean:message key="replication.info.mountpoint"/>
            </nssorttab:column>
            <nssorttab:column name="checkPoint" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
					<bean:message key="original.list.th.checkpoint"/>
            </nssorttab:column>
        </nssorttab:table>
        <br>
        <nested:nest property="originalInfo">
            <nested:hidden property="filesetName" />
            <nested:hidden property="connectionAvailable" />
            <nested:hidden property="transInterface" />
            <nested:hidden property="bandWidth" />
            <nested:hidden property="replicaHost" />
            <nested:hidden property="mountPoint" />
            <nested:hidden property="hasMounted" />
            <nested:hidden property="type"/>
            <nested:hidden property="volSyncInFileset"/>
			<nested:hidden property="hour"/>
			<nested:hidden property="minute"/>
			<nested:hidden property="repliMethod"/>                  
        </nested:nest>

       
  </logic:notEmpty>
   <input type="hidden" name="operation"/> 

</html:form>
</body>
</html>


