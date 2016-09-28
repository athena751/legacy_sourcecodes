<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrtab.jsp,v 1.2 2008/05/24 09:03:33 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="taglib-nstab" prefix="nstab"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<html>
<%@ include file="../../common/head.jsp"%>
<LINK href="<%=request.getContextPath()%>/skin/default/tab.css" type=text/css rel=stylesheet>
<SCRIPT language=JavaScript src="../common/tab.js"></SCRIPT>
<body>
<div class="h1"><h1 class="title"><bean:message key="ddr.h1"/></h1></div>
<nstab:nstab displayonload="0">
    <nstab:subtab url="/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairList.do?operation=display">
    	<bean:message key="tab.pairList"/>
  	</nstab:subtab>
    
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ISNSVIEW%>" value="false" scope="session" >  	
	    <nstab:subtab url="/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairCreateShow.do?operation=showAlways&clearFormBeanInSession=true">
	    	<bean:message key="tab.d2dAlwaysRepl"/>
	    </nstab:subtab>
	    
	    <nstab:subtab url="/nsadmin/framework/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairCreateShow.do?operation=showGeneration&clearFormBeanInSession=true">
	    	<bean:message key="tab.d2dBackup"/>
	    </nstab:subtab>
	</logic:equal>    
</nstab:nstab>
</body>
</html>