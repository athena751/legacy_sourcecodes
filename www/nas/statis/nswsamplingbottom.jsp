<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingbottom.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.CollectionConst3" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
    <script language="javascript">
    var bottomLoadFlag=0;
    function onBottomLoad(){
        bottomLoadFlag=1;
        if(parent.nswsamplinglist&&parent.nswsamplinglist.listLoadFlag==1){
            if(parent.nswsamplinglist.listLength==0){
                document.forms[0].samplingStartBtn.disabled=true;
                document.forms[0].samplingStopBtn.disabled=true;
            }
        }
    }
    function OnSamplingStartBtn(){
        if(btnCommon("startFlag")){
            parent.nswsamplinglist.document.forms[0].action="nswsampling.do?operation=toSettingFrame";
            parent.nswsamplinglist.document.forms[0].submit();
            setSubmitted();
        }
	        
    }
    function OnSamplingStopBtn(){
        if(btnCommon("stopFlag")){
            if(confirm("<bean:message key="statis.nsw_sampling.stopsampling"/>")){
                parent.nswsamplinglist.document.forms[0].action="nswsampling.do?operation=stopSampling";
                parent.nswsamplinglist.document.forms[0].submit();
                setSubmitted();
            }
        }
    }

    function btnCommon(flag){
        if(!parent.nswsamplinglist){
            return false;
        }
        if(!parent.nswsamplinglist.listLoadFlag){
            return false;
        }
        if(parent.nswsamplinglist.listLoadFlag==0){
            return false;
        }
        if(isSubmitted()){
            return false;
        }
        <logic:notEqual name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
	        var checkboxList=parent.nswsamplinglist.document.forms[0].idList;
	        if(checkboxList.length==null){
	            if(checkboxList.checked==true){
	                return true;
	            }
	        }else{
	            for(var i=0;i<checkboxList.length;i++){
	                if(checkboxList[i].checked==true){
	                    return true;
	                }
	            }
	        }
	        var colItemStr;
	        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_VIRTUAL_PATH%>">
	           if(flag=="stopFlag"){
	               alert("<bean:message key="common.alert.failed" bundle="common"/>"+"\r\n"+"<bean:message key="statis.nsw_sampling.checkbox.noresource_vp"/>");
	           }else{
	               alert("<bean:message key="statis.nsw_sampling.checkbox.noresource_vp"/>");
	           }
	        </logic:equal>
	        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_SEVER%>">
	           if(flag=="stopFlag"){
	               alert("<bean:message key="common.alert.failed" bundle="common"/>"+"\r\n"+"<bean:message key="statis.nsw_sampling.checkbox.noresource_server"/>");
	           }else{
	               alert("<bean:message key="statis.nsw_sampling.checkbox.noresource_server"/>");
	           }
	        </logic:equal>
	        return false;
        </logic:notEqual>
        <logic:equal name="<%=CollectionConst3.STATIS_NSW_SAMPLING_COLITEM_ID%>" scope="session" value="<%=CollectionConst3.STATIS_NFS_NODE%>">
                return true;
        </logic:equal>
    }
    </script>
</head>
<body onload="onBottomLoad();">
<form>
    <html:button property="samplingStartBtn" onclick="OnSamplingStartBtn()">
        <bean:message key="statis.nsw_sampling.button.samplingstart"/>
    </html:button>
    <html:button property="samplingStopBtn" onclick="OnSamplingStopBtn()">
        <bean:message key="statis.nsw_sampling.button.samplingstop"/>
    </html:button>
<form>
</body>
</html>
