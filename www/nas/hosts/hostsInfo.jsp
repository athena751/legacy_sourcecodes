<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 

<!-- "@(#) $Id: hostsInfo.jsp,v 1.1 2006/05/19 03:32:31 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head>
<frameset rows="*,60"   border=1 >
   <frame name="hostsinfotop"        src="../../hosts/hostsInfoTop.do"  border=0 > 
   <frame name="hostsinfobottom"    src="../../hosts/hostsInfoBottom.do" 
      class="TabBottomFrame">   
</frameset>
</html>
