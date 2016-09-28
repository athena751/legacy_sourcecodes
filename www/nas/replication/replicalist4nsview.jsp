<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicalist4nsview.jsp,v 1.8 2008/10/09 09:52:21 chenb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="replicationcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
</head>

<body onload="setHelpAnchor('replication_5');">
<html:button property="reloadBtn" onclick="return loadReplicaList();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>

<br><br>
<form>    
    <logic:empty name="replicaInfoList" scope="request">
        <bean:message key="replica.info.noReplica"/>
    </logic:empty>
    <logic:notEmpty name="replicaInfoList" scope="request">
        <bean:define id="replicaInfoList" name="replicaInfoList" scope="request" type ="java.util.ArrayList"/>
        <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)replicaInfoList)%>" 
                        id="replicaList" 
                        table="border=1" 
                        sortonload="originalServer:ascend">
          
            <nssorttab:column name="originalServer"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="yes">
                <bean:message key="replication.info.oriservername"/>
            </nssorttab:column>
            
            <nssorttab:column name="filesetName"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="yes">
                <bean:message key="replication.info.filesetname"/>
            </nssorttab:column>            

            <nssorttab:column name="connected"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replica.th.connected"/>
            </nssorttab:column>                              

            <nssorttab:column name="syncRate"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replica.th.syncRate"/>
            </nssorttab:column>

            <nssorttab:column name="transInterface"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replication.info.interface"/>
            </nssorttab:column>    

            <nssorttab:column name="replicationData"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replication.info.replidata"/>
            </nssorttab:column>    
            
            <nssorttab:column name="mountPoint"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="yes">
                <bean:message key="replication.info.mountpoint"/>
            </nssorttab:column>

            <nssorttab:column name="snapKeepLimit"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replication.th.snapKeep"/>
            </nssorttab:column>            

            <logic:notEqual name="isNashead" value="true" scope="session">
                <logic:equal name="asyncReplica" value="true" scope="session">
                    <nssorttab:column name="asyncStatus"
                                      th="STHeaderRender"
                                      td="com.nec.nsgui.action.replication.STDataRender4Replica"
                                      sortable="no">
                        <bean:message key="info.asyncStatus" bundle="volume/replication"/>
                    </nssorttab:column>
                    <logic:equal name="asyncErr" value="true" scope="session">
                        <nssorttab:column name="errCode"
                                          th="STHeaderRender"
                                          td="com.nec.nsgui.action.replication.STDataRender4Replica"
                                          sortable="no">
                            <bean:message key="info.errCode" bundle="volume/replication"/>
                        </nssorttab:column>
                    </logic:equal>           
                </logic:equal>             
            </logic:notEqual>      
                                                                                    
        </nssorttab:table>
    </logic:notEmpty>    
</form>
</body>
</html:html>