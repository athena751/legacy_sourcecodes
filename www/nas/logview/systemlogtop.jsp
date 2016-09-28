<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: systemlogtop.jsp,v 1.9 2008/05/09 05:09:14 hetao Exp $" -->


<%@ page import="java.util.ArrayList" %>
<%@ page import="com.nec.nsgui.action.syslog.SyslogActionConst" %>
<%@ page import="com.nec.nsgui.model.entity.syslog.SyslogCategoryInfoBean" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<bean:define id="h1_Key" name="<%=SyslogActionConst.SESSION_NAME_H1_KEY%>" type="java.lang.String"/>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var hasLoaded = 0;
var sizeForHeartbeat = '<bean:write name="fileSize" scope="request"/>';
function init(){
    hasLoaded = 1;
    if(window.parent.bottomframe.document.forms[0]){
        window.parent.bottomframe.changeButtonStatus();
        <logic:empty name="categoryList" scope="request">
            window.parent.bottomframe.disableButtons();
        </logic:empty>
    }
    <logic:notEmpty name="categoryList" scope="request">
        document.forms[0].elements["commonInfo.logName"].value="<bean:message key="<%=h1_Key%>"/>";
        setKeyWords();
        document.forms[0].elements["systemSearchInfo.allKeywords"].value=spellAllKeywords();
    </logic:notEmpty> 
}

<logic:notEmpty name="categoryList" scope="request">
    function checkInputs(){
        //this function is called by the "bottomframe"
        if(document.forms[0].displayingKeyword){
            if(document.forms[0].displayingKeyword.value=="<bean:message key="syslog.system.info_select"/>"){
                alert("<bean:message key="syslog.common.alert.needInputCategory"/>");
                return false;
            }
        }
        return true;
    }
    var categoryLabels = new Array();
    function setKeyWords(){
        var searchKeyWordDisplaying = "";
        if(categoryLabels.length >1 ){
            //there is two or more
            for(var i=0; i < categoryLabels.length; i++){
                if(document.forms[0].elements["systemSearchInfo.searchKeyword"][i].checked){
                    searchKeyWordDisplaying = searchKeyWordDisplaying + "("+categoryLabels[i]+")"
                            + document.forms[0].elements["systemSearchInfo.searchKeyword"][i].value
                            + "|";
                }
            }
            searchKeyWordDisplaying = searchKeyWordDisplaying.replace(/[|]$/g,"");
        }else{
            //only one
            if(document.forms[0].elements["systemSearchInfo.searchKeyword"].checked){
                searchKeyWordDisplaying = "("+categoryLabels[0]+")"
                            + document.forms[0].elements["systemSearchInfo.searchKeyword"].value;
            }
        }
        if(searchKeyWordDisplaying != ""){
            document.forms[0].displayingKeyword.value=searchKeyWordDisplaying;
        }else{
            document.forms[0].displayingKeyword.value="<bean:message key="syslog.system.info_select"/>";
        }
    }
    
    function changeCategoryStatus(checkedFlag){
        if(categoryLabels.length > 1){
            for(var i=0; i < categoryLabels.length; i++){
                document.forms[0].elements["systemSearchInfo.searchKeyword"][i].checked=checkedFlag;
            }
        }else{
            document.forms[0].elements["systemSearchInfo.searchKeyword"].checked=checkedFlag;
        }
    }
    
    function checkall(){
        changeCategoryStatus(true);
        setKeyWords();
    }
    
    function uncheckall(){
        changeCategoryStatus(false);
        setKeyWords()
    }
    
    function spellAllKeywords(){
        var searchKeyWordDisplaying = "";
        if(categoryLabels.length > 1){
            //there is two or more
            for(var i=0; i < categoryLabels.length; i++){
                    searchKeyWordDisplaying = searchKeyWordDisplaying 
                     + document.forms[0].elements["systemSearchInfo.searchKeyword"][i].value
                            + "|";
            }
           return searchKeyWordDisplaying.replace(/[|]$/g,"");
        }else{
            searchKeyWordDisplaying = document.forms[0].elements["systemSearchInfo.searchKeyword"].value;
        }
        return searchKeyWordDisplaying;
    }
</logic:notEmpty>
function onRefresh(){
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="enterSyslog.do?operation=enterSyslog&logType=systemLog";
}
</script>
</head>
<body onload="init();">
<html:form action="syslog.do?operation=beginSearch" method="post" >
<h1 class="title"><bean:message key="<%=h1_Key%>"/></h1>
    <html:button property="refreshBtn" onclick="onRefresh();">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
<logic:empty name="categoryList" scope="request">  
    <br><p><bean:message key="syslog.system.alert.noCategory"/></p>
</logic:empty>
<logic:notEmpty name="categoryList" scope="request">   
<h2 class="title"><bean:message key="syslog.common.h2_logInfo"/></h2>

<table border="1" width="85%">
    <tr>
        <th width="50%"><bean:message key="syslog.common.th_logFile"/></th>
        <th><bean:message key="syslog.common.th_fileSize"/></th>
    </tr>
    <tr>
        <td><%=SyslogActionConst.SYSTEM_LOG_FILE_NAME%></td>
        <logic:equal name="fileSizeForDisplay" value="">
        	<td align="center"><bean:message key="syslog.common.value_unknownSize"/></td>
        </logic:equal>
        <logic:notEqual name="fileSizeForDisplay" value="">
        	<td align="right"><bean:write name="fileSizeForDisplay"/></td>
        </logic:notEqual>
    </tr>
</table>

 
<h2 class="title"><bean:message key="syslog.common.h2_viewSet"/></h2>
<nested:nest property="commonInfo">
<nested:hidden property="logFile"/>
<nested:hidden property="logType"/>
<nested:hidden property="logName"/>
<nested:hidden property="searchAction"/>

<table border="1" class="Vertical" width="85%">
<tr>
    <th width="20%"><bean:message key="syslog.common.th_viewLines"/></th>
    <td colspan="2">
        <nested:select property="viewLines">
            <html:optionsCollection name="maxLinesSet" />
        </nested:select>
    </td>
</tr>
<tr>
    <th><bean:message key="syslog.common.th_viewOrder"/></th>
    <td>
      <nested:radio property="viewOrder" styleId="view_form_new" value="new"/>
      <label for="view_form_new"><bean:message key="syslog.common.td_newOrder"/></label>
        &nbsp;&nbsp;&nbsp;
      <nested:radio property="viewOrder" styleId="view_form_old" value="old"/>
      <label for="view_form_old"><bean:message key="syslog.common.td_oldOrder"/></label>
    </td>
</tr>
</table>
<h2 class="title"><bean:message key="syslog.common.h2_searchOptionSet"/></h2>
</nested:nest>


<h3 class="title"><bean:message key="syslog.system.h3_selectCategory"/></h3>
<nested:nest property="systemSearchInfo">
<nested:hidden property="allKeywords"/>
<table border="1" width="65%">
    <tr>
        <th rowspan="5" colspan="1"><bean:message key="syslog.system.th_selectCategory"/></th>
    </tr>
    
    <tr><td rowspan="1"><input type="button"  name="allCategory" onclick="checkall()"
                value="<bean:message key="syslog.system.button_allCategory"/>" >
            <input type="button"  name="allCategory" onclick="uncheckall()"
                value="<bean:message key="syslog.system.button_noCategory"/>" >
	</td>
    </tr>
    <tr><td colspan="2">
        <table border="0" width="100%">
        <bean:define id="categoryList" name="categoryList" type="java.util.ArrayList"/>
        <%int categoryNumber = categoryList.size();
        for(int i = 0; i < categoryNumber; i++){
            if(i % 3 == 0){%>
                <tr>
            <%}%>
            <%SyslogCategoryInfoBean category = (SyslogCategoryInfoBean)categoryList.get(i);
            %>
                <td width="33%" nowrap>
                    <nested:multibox property="searchKeyword" styleId="<%=category.getCategory()%>" onclick="setKeyWords();">
                    <%=category.getKeyword()%>
                    </nested:multibox>
                    <label for="<%=category.getCategory()%>"><%=category.getCategoryLabel()%></label>
                    <script language="JavaScript">
                        categoryLabels[<%=i%>]="<%=category.getCategoryLabel()%>";
                    </script>
                </td>
            <%if(i % 3 == 2){%>
                </tr>
            <%}%>
        <%}%>
        <%if(categoryNumber % 3 != 0){%>
            </tr>
        <%}%>
        </table>
        </td>
    </tr>
    <tr>
        <th rowspan="1" colspan="2" align="center"><bean:message key="syslog.system.th_keyword"/></th>
    </tr>
    <tr>
        <td rowspan="1" colspan="2"><textarea  name="displayingKeyword" rows="5" cols="65" readonly ></textarea></td>
    </tr>
</table>
</nested:nest>


<nested:nest property="commonInfo">
<h3 class="title"><bean:message key="syslog.common.h3_searchOption"/></h3>
  <table border="1" class="Vertical" width="85%">
  <tr>
    <td width="20%"><bean:message key="syslog.common.th_searchWords"/></td>
    <td>
        <nested:text property="searchWords" size="53" maxlength="128"/>
    </td>
  </tr>
  <tr>
    <td colspan="2">
        <nested:radio property="containWords" styleId="containWords" value="yes"/>
        <label for="containWords"><bean:message key="syslog.common.radio_containWords"/></label>&nbsp;
        <nested:radio property="containWords" styleId="containNoWords" value="no"/>
        <label for="containNoWords"><bean:message key="syslog.common.radio_containNoWords"/></label>
    </td>
  </tr>
  <tr>
    <td colspan="2">
        <nested:checkbox property="caseSensitive" styleId="caseSensitive" value="yes"/>
        <label for="caseSensitive"><bean:message key="syslog.common.checkbox_caseSensitive"/></label>
    </td>
  </tr>
  <tr>
    <td><bean:message key="syslog.common.th_aroundLines"/></td>
    <td>
        <nested:text property="aroundLines" size="53" maxlength="2"/>
    </td>
  </tr>
 </table>
</nested:nest>
</logic:notEmpty>
</html:form>
<form name="directDownloadForm" action="syslog.do?operation=directDownload" method="post">
    <input type="hidden" name="isPerformance4directDown" value=""/>
    <input type="hidden" name="logFile4directDown" value=""/>
    <input type="hidden" name="displayEncoding4directDown" value=""/>
    <input type="hidden" name="logType4directDown" value=""/>
    <input type="hidden" name="cifsSearchEncoding" value=""/>
    <input type="hidden" name="systemAllSearchKeywords" value=""/>
</form>
</body>
</html>