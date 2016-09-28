<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: accounttablisttop.jsp,v 1.1 2005/10/19 01:22:00 fengmh Exp $" -->
<%@ page session="true"%>
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var buttonEnable = 0;
	function enableSet() {
			<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
	            value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
	            <logic:notEmpty name="<%= NSActionConst.NSUSER_NSVIEW %>" scope="request">
			        buttonEnable = 1;
					if(window.parent.frames[1].document) {
						if(window.parent.frames[1].document.forms[0]) {
							window.parent.frames[1].changeButtonStatus();
						}
					}
			    </logic:notEmpty>
			</logic:equal>
	}
	
	function init() {
		<logic:empty name="<%= NSActionConst.NSUSER_NSVIEW %>" scope="request">
		if(window.parent.frames[1].document) {
			if(window.parent.frames[1].document.forms[0]) {
				parent.frames[1].document.forms[0].elements["nsviewOut"].disabled = "true";
			}
		}
		</logic:empty>
	}

function onReload(){
    if (isSubmitted()){
        return false;
    }  
    setSubmitted();
    <logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
	value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
        parent.window.location = "/nsadmin/account/accountTablist.do";
    </logic:equal>
    <logic:notEqual name="<%= NSActionConst.SESSION_USERINFO %>"
	value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
        window.location = "/nsadmin/account/accountTablistTop.do?operation=redirect";
    </logic:notEqual>
}

function onNsviewOut() {
    if (isSubmitted()){
		return false;
	}
		
	var size = 0;
	var sessionNames = "";
	if(document.forms[0].checkboxId) {
		size = document.forms[0].checkboxId.length;
		if(!size && document.forms[0].checkboxId.checked) {
			sessionNames += document.forms[0].checkboxId.value;
		} else {
			for(var i=0; i<size; i++) {
				if(document.forms[0].checkboxId[i].checked) {
					sessionNames += document.forms[0].checkboxId[i].value + " ";
				}
			}
		}
		document.forms[0].elements["sessionId"].value = sessionNames;
		if(sessionNames != "") {
			if(confirm("<bean:message key="account.timeout.disconnectConfirm"/>"
			 + "\r\n" + "<bean:message key="common.confirm" bundle="common"/>")) {
				setSubmitted();
				document.forms[0].submit();
				return true;
			}
		} else {
			alert("<bean:message key="account.tablist.notChoice" />");
			return;
		}
	}
}

</script>
</head>
<body
	onload="setHelpAnchor('system_account_1');displayAlert();enableSet();init();">
<html:form action="accoutNsviewOut.do" method="post" target="_parent">
	<displayerror:error h1_key="account.common.h1" />
	<html:button property="reload" onclick="onReload()">
		<bean:message key="common.button.reload" bundle="common" />
	</html:button>
	<h3><bean:message key="account.list.nsadmin.h3" /></h3>
	<logic:empty name="<%= NSActionConst.NSUSER_NSADMIN %>" scope="request">
		<bean:message key="account.list.nouser" />
	</logic:empty>
	<logic:notEmpty name="<%= NSActionConst.NSUSER_NSADMIN %>"
		scope="request">
		<bean:define id="tableModena"
			name="<%= NSActionConst.NSUSER_NSADMIN %>" scope="request" />
		<nssorttab:table tablemodel="<%= (SortTableModel)tableModena %>"
			id="list1" table="border=1" sortonload="from:ascend">
			<nssorttab:column name="from"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="no">
				<bean:message key="account.list.from" />
			</nssorttab:column>

			<nssorttab:column name="loginTime"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="no">
				<bean:message key="account.list.logintime" />
			</nssorttab:column>

			<nssorttab:column name="lastAccessTime"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="no">
				<bean:message key="account.list.lasttime" />
			</nssorttab:column>

			<nssorttab:column name="idleTime"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.action.account.STDataListRender4Account"
				sortable="no">
				<bean:message key="account.list.idleTime" />
			</nssorttab:column>

			<nssorttab:column name="timeout"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.action.account.STDataListRender4Account"
				sortable="no">
				<bean:message key="account.list.timeouttable" />
			</nssorttab:column>
		</nssorttab:table>
	</logic:notEmpty>
	<h3><bean:message key="account.list.nsview.h3" /></h3>
	<logic:empty name="<%= NSActionConst.NSUSER_NSVIEW %>" scope="request">
		<bean:message key="account.list.nouser" />
	</logic:empty>
	<logic:notEmpty name="<%= NSActionConst.NSUSER_NSVIEW %>"
		scope="request">
		<bean:define id="tableModenv"
			name="<%= NSActionConst.NSUSER_NSVIEW %>" scope="request" />
		<nssorttab:table tablemodel="<%= (SortTableModel)tableModenv %>"
			id="list2" table="border=1" sortonload="from:ascend">
			<logic:equal name="<%= NSActionConst.SESSION_USERINFO %>"
				value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
				<nssorttab:column name="checkboxId"
					th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
					td="com.nec.nsgui.action.account.STDataListRender4Account"
					sortable="no">
				</nssorttab:column>
				<nssorttab:column name="from"
					th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
					td="com.nec.nsgui.action.account.STDataListRender4Account"
					sortable="no">
					<bean:message key="account.list.from" />
				</nssorttab:column>
			</logic:equal>
			<logic:notEqual name="<%= NSActionConst.SESSION_USERINFO %>"
				value="<%= NSActionConst.NSUSER_NSADMIN %>" scope="session">
				<nssorttab:column name="from"
					th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
					td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="no">
					<bean:message key="account.list.from" />
				</nssorttab:column>
			</logic:notEqual>

			<nssorttab:column name="loginTime"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="no">
				<bean:message key="account.list.logintime" />
			</nssorttab:column>

			<nssorttab:column name="lastAccessTime"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.taglib.nssorttab.STDataRender" sortable="no">
				<bean:message key="account.list.lasttime" />
			</nssorttab:column>

			<nssorttab:column name="idleTime"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.action.account.STDataListRender4Account"
				sortable="no">
				<bean:message key="account.list.idleTime" />
			</nssorttab:column>

			<nssorttab:column name="timeout"
				th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
				td="com.nec.nsgui.action.account.STDataListRender4Account"
				sortable="no">
				<bean:message key="account.list.timeouttable" />
			</nssorttab:column>
		</nssorttab:table>
		<html:hidden property="sessionId" value="" />
	</logic:notEmpty>
</html:form>
</body>
</html>
