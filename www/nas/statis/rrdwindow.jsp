<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdwindow.jsp,v 1.7 2005/10/24 12:24:46 pangqr Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst" %>
<%@ page import="com.nec.nsgui.model.biz.statis.WatchItemDef" %>
<html>
<head>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">
var listInvestWin;
var listMaxWin=new Array();
var listMaxWinName=new Array();
var detailMaxWin;
var detailInvestWin;
function closeWin(){

    for(var i=0;i<listMaxWinName.length;i++){
  		if(listMaxWin[listMaxWinName[i]] !=null&& !listMaxWin[listMaxWinName[i]].closed){
           listMaxWin[listMaxWinName[i]].close();
        }
    }
    if(listInvestWin != null&& !listInvestWin.closed){
		listInvestWin.close();
	}
    if(detailMaxWin != null&& !detailMaxWin.closed){
		detailMaxWin.close();
	}
    if(detailInvestWin!= null && !detailInvestWin.closed){
		detailInvestWin.close();
	}

}
</script>
</head>
<body onunload="closeWin();">
</body>

</html>
