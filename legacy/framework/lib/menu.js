/*
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: menu.js,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"
*/

function        setHelpURL(help, target)
{
	parent.CONTROLL.document.controll.helpURL.value = help;
	parent.CONTROLL.document.controll.checkTarget.value = target;
}

function	setMenuHistory(history)
{
	parent.HISTORY.document.open();
	parent.HISTORY.document.bgColor = "black";
	parent.HISTORY.document.fgColor = "white";
	parent.HISTORY.document.write('<html>');
	parent.HISTORY.document.write('<head>');
	parent.HISTORY.document.write('</head>');
	parent.HISTORY.document.write('<body TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" bgcolor="black" text="white">');
	
	parent.HISTORY.document.write('<span style="font-size: 8pt; font-mamily: sans-self">');
	parent.HISTORY.document.write(history);
	parent.HISTORY.document.write('</span>');
	parent.HISTORY.document.write('</body>');
	parent.HISTORY.document.write('</html>');
	parent.HISTORY.document.close();
}
