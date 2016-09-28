<!--
        Copyright (c) 2004-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: title.jsp,v 1.9 2007/08/23 02:54:47 liul Exp $" -->
<html>
<head>
<style type="text/css">
<!--
    .neclogo{
        margin-top:0px;
        margin-left:0px;
    }
-->
</style>
<script language="JavaScript">
var logout = 0;
var menuLock = 0;
var exportGroup;
var changeNode;
function openLogout(){
    if (top.window.opener!=null){
            top.window.opener.focus();
    }
    window.open("/nsadmin/framework/logout.do","LOGOUT","location=0,directories=0,status=0,menubar=0,resizable=1,width=600,height=200");
}
</script>
</head>
<body leftmargin="0" background="images/nation/bk_head0.gif" 
	topmargin="0" marginwidth="0" marginheight="0"  onUnload="if(!logout) openLogout();return true">
<img src="images/nation/new_logo_title.gif" alt="StorageManager" align="left">
<img src="images/nation/NEC_white_m.gif" alt="StorageManager" align="right" class="neclogo">
</body>
</html>