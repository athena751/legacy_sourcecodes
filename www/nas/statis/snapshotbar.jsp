<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snapshotbar.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-html"    prefix="html" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>
<%@ taglib uri="struts-logic"   prefix="logic"%>

<html>
<head>
	<%@include file="../../common/head.jsp" %>
	<script language="JavaScript" src="../common/common.js"></script>
	<script language="JavaScript">
	    var needAlert = false;
        function init(){
           if(needAlert){
                alert("<bean:message key="statis.snapshot.cluster.maintenance"/>");
           }
        }
        function submitOrderByKey(i,key) {
			if (isSubmitted()){
			    return false;
			}
            if(document.forms[0].elements["sortKey"][i].value == key){
                document.forms[0].elements["orderFlag"][i].value = (document.forms[0].elements["orderFlag"][i].value == "false");
            }else{
                document.forms[0].elements["sortKey"][i].value = key;
                document.forms[0].elements["orderFlag"][i].value = true;
            }
            document.forms[0].submit();
            setSubmitted();
            return true;
        }
        function submitOnClickOS(){
            if (isSubmitted()){
                return false;
            }
            if(document.forms[0].OSCheck.checked == true){
               document.forms[0].displayOSInfo.value = "true"; 
            }else{
               document.forms[0].displayOSInfo.value = "false";  
            }
            setSubmitted();
            document.forms[0].submit();    
        }
	</script>
</head>

<body onload="init()">
<html:form action="snapshot.do?operation=displayList">
<input type="hidden" name="sortKey" value="<bean:write name="snapshotForm" property="sortKey[0]"/>">
<input type="hidden" name="sortKey" value="<bean:write name="snapshotForm" property="sortKey[1]"/>">
<input type="hidden" name="orderFlag" value="<bean:write name="snapshotForm" property="orderFlag[0]"/>">
<input type="hidden" name="orderFlag" value="<bean:write name="snapshotForm" property="orderFlag[1]"/>">
<html:hidden property="graphType"/>
<html:hidden property="displayOSInfo"/>
<input type="submit" name="refresh" value="<bean:message key='common.button.reload' bundle='common'/>">
<input type="checkbox" name="OSCheck"id="displayos" onclick="submitOnClickOS()"
<logic:equal name="snapshotForm" property="displayOSInfo" value="true">
    checked 
</logic:equal>
><label for="displayos"><bean:message key="statis.snapshot.os.display"/></label>

<logic:iterate id="targetInfo" name="graphInfoList" indexId="tarInx">
    <logic:equal name="targetInfo" property="returnValue" value="2" >
		<script language="JavaScript">
            needAlert = true;
		</script>
    </logic:equal>
    <h3 class="title">
        <logic:equal name="isCluster" value="true">
            <bean:message key='RRDGraph.node' arg0='<%=tarInx.toString()%>'/>
        </logic:equal>
        <bean:write name="targetInfo" property="nickName"/>
    </h3>
    
	<logic:equal name="targetInfo" property="returnValue" value="0" >
	    <logic:equal name="targetInfo" property="graphTableHtml" value="" >
	        <br><table border ="0"><tr><td>
	            <bean:message key="statis.snapshot.message_nodevices"/>
	        </td></tr></table><br>
	    </logic:equal>
        
	    <logic:notEqual name="targetInfo" property="graphTableHtml" value="">
		    <table name="bar" border=1>
		        <tr>
		            <th align="center"> <bean:message key="statis.snapshot.common.href_graph"/> </th>
		            <th align="center">
		                <input type="button" name="orderbyuse" onclick="return submitOrderByKey(<%=tarInx%>,'use');" 
		                       value="<bean:message key="statis.snapshot.common.href_use"/>">
		            </th>
		            <logic:equal name="SESSION_STATIS_WATCHITEM_ID" value="Disk_Used_Rate" scope="session">
		            <th align="center">
		                <input type="button" name="orderbytotal" onclick="return submitOrderByKey(<%=tarInx%>,'total');" 
		                       value="<bean:message key="statis.snapshot.common.href_total_GB"/>">
		            </th>
		            <th align="center">
		                <input type="button" name="orderbyused" onclick="return submitOrderByKey(<%=tarInx%>,'used');" 
		                       value="<bean:message key="statis.snapshot.common.href_used_GB"/>">
		            </th>
		            <th align="center">
		                <input type="button" name="orderbyavailable" onclick="return submitOrderByKey(<%=tarInx%>,'available');" 
		                       value="<bean:message key="statis.snapshot.common.href_avai_GB"/>">
		            </th>
		            </logic:equal>
		            <logic:notEqual name="SESSION_STATIS_WATCHITEM_ID" value="Disk_Used_Rate" scope="session">
                    <th align="center">
                        <input type="button" name="orderbytotal" onclick="return submitOrderByKey(<%=tarInx%>,'total');" 
                               value="<bean:message key="statis.snapshot.common.href_total"/>">
                    </th>
                    <th align="center">
                        <input type="button" name="orderbyused" onclick="return submitOrderByKey(<%=tarInx%>,'used');" 
                               value="<bean:message key="statis.snapshot.common.href_used"/>">
                    </th>
                    <th align="center">
                        <input type="button" name="orderbyavailable" onclick="return submitOrderByKey(<%=tarInx%>,'available');" 
                               value="<bean:message key="statis.snapshot.common.href_avai"/>">
                    </th>
                    </logic:notEqual>
		            <th align="center">
		                <bean:message key="statis.snapshot.common.href_type"/>
		            </th>
		            <th align="center">
		                <input type="button" name="orderbydevice" onclick="return submitOrderByKey(<%=tarInx%>,'device');" 
	                            value="<bean:message key="statis.snapshot.common.href_device"/>">
		            </th>
		            <th align="center">
		                <input type="button" name="orderbymp" onclick="return submitOrderByKey(<%=tarInx%>,'mountPoint');" 
		                       value="<bean:message key="statis.snapshot.common.href_mp"/>">
		            </th>
		        </tr>
		        <bean:write name="targetInfo" property="graphTableHtml" filter="false"/>
		    </table>
	    </logic:notEqual>
	</logic:equal>
	
    <logic:equal name="targetInfo" property="returnValue" value="2" >
        <br><table border ="0"><tr><td>
            <bean:message key="statis.snapshot.cluster.maintenance"/>
        </td></tr></table><br>
    </logic:equal>
</logic:iterate>

</html:form>
</body>
</html>