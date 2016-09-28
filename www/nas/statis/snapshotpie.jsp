<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: snapshotpie.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-html"    prefix="html" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>
<%@ taglib uri="struts-logic"   prefix="logic"%>

<html>
<head>
	<%@include file="../../common/head.jsp" %>
	<script language="JavaScript" src="../common/common.js"></script>
	<script language="JavaScript">
	    var hasDevInfo = false;
	    var needAlert = false;
	    function init(){
	       if(!hasDevInfo){
	           document.forms[0].orderbyname.disabled = true;   
	           document.forms[0].orderbyrate.disabled = true;
	       }
	       if(needAlert){
                alert("<bean:message key="statis.snapshot.cluster.maintenance"/>");
	       }
	    }
        function submitOrderByKey(key) {
            if (isSubmitted()){
                return false;
            }
            if(document.forms[0].elements["sortKey"][0].value == key){
                document.forms[0].elements["orderFlag"][0].value = (document.forms[0].elements["orderFlag"][0].value == "false");
                document.forms[0].elements["orderFlag"][1].value = (document.forms[0].elements["orderFlag"][1].value == "false");
            }else{
                document.forms[0].elements["sortKey"][0].value = key;
                document.forms[0].elements["orderFlag"][0].value = true;
                document.forms[0].elements["sortKey"][1].value = key;
                document.forms[0].elements["orderFlag"][1].value = true;
            }
            document.forms[0].submit();
            setSubmitted();
            return true;
        }
		var dataWinArray = new Array(25);
		var fileWinArray = new Array(25);
		function closeWin(){
			var i=1;
			for(i=1;i<=dataWinArray.length;i++){
			    if(dataWinArray[i]&&!(dataWinArray[i].closed)){
			        dataWinArray[i].close();
			        dataWinArray[i] = null;
			    }
			}
			for(i=1;i<=fileWinArray.length;i++){
			    if(fileWinArray[i]&&!(fileWinArray[i].closed)){ 
			        fileWinArray[i].close();
			        fileWinArray[i] = null;
			    }
			}
		}
		function createWin(arrayFlag,hexWinName,subItemID){
		    var winName = arrayFlag + hexWinName;
		    if(arrayFlag == "data"){
		        for(var i=1; i <= dataWinArray.length; i++){
	                if(dataWinArray[i]&&!(dataWinArray[i].closed)){ 
	                    if(dataWinArray[i].name == winName){
	                        dataWinArray[i].focus();
	                        return;
	                    }
	                }
	            }
	            for(var i=1; i <= dataWinArray.length; i++){
	                if(dataWinArray[i]==null||dataWinArray[i].closed){
	                    dataWinArray[i] = open("snapshot.do?operation=displayDetail&subItem="+subItemID,  winName,   "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=320");
	                    return;
	                }
	            }
		    }else{
		        for(var i=1; i <= fileWinArray.length; i++){
	                if(fileWinArray[i]&&!(fileWinArray[i].closed)){ 
	                    if(fileWinArray[i].name == winName){
	                        fileWinArray[i].focus();
	                        return;
	                    }
	                }
	            }
	            for(var i=1; i <= fileWinArray.length; i++){
	                if(fileWinArray[i]==null||fileWinArray[i].closed){
	                    fileWinArray[i] = open("snapshot.do?operation=displayDetail&subItem="+subItemID , winName, "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=320");
	                    return;
	                }
	            }
		    }
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

<body onload="init()" onunload="closeWin()">
<html:form action="snapshot.do?operation=displayList" >

<html:hidden property="graphType"/>
<input type="hidden" name="sortKey" value="<bean:write name="snapshotForm" property="sortKey[0]"/>">
<input type="hidden" name="sortKey" value="<bean:write name="snapshotForm" property="sortKey[1]"/>">
<input type="hidden" name="orderFlag" value="<bean:write name="snapshotForm" property="orderFlag[0]"/>">
<input type="hidden" name="orderFlag" value="<bean:write name="snapshotForm" property="orderFlag[1]"/>">
<html:hidden property="displayOSInfo"/>
<input type="submit" name="refresh" value="<bean:message key='common.button.reload' bundle='common'/>">
<input type="checkbox" name="OSCheck" id="displayos" onclick="submitOnClickOS()"
<logic:equal name="snapshotForm" property="displayOSInfo" value="true">
    checked 
</logic:equal>
><label for="displayos"><bean:message key="statis.snapshot.os.display"/></label>
<p>
<input type="button" name="orderbyname" onclick="return submitOrderByKey('mountPoint');" value="<bean:message key="statis.snapshot.pie.button_orderbyname"/>">&nbsp;&nbsp;
<input type="button" name="orderbyrate" onclick="return submitOrderByKey('use');" value="<bean:message key="statis.snapshot.pie.button_orderbyrate"/>">
</p>

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
		<logic:equal name="targetInfo" property="graphTableHtml" value="">
		    <br><table border ="0"><tr><td>
		        <bean:message key="statis.snapshot.message_nodevices"/>
		    </td></tr></table><br>
		</logic:equal>
		<logic:notEqual name="targetInfo" property="graphTableHtml" value="">
		    <script language="JavaScript">
                hasDevInfo = true;
            </script>  
		    <bean:write name="targetInfo" property="graphTableHtml" filter="false"/>
		</logic:notEqual>
    </logic:equal>
    
    <logic:equal name="targetInfo" property="returnValue" value="2">
        <br><table border ="0"><tr><td>
            <bean:message key="statis.snapshot.cluster.maintenance"/>
        </td></tr></table><br>
    </logic:equal>
</logic:iterate>

</html:form>
</body>
</html>
