/*
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
*/

/* "@(#) $Id: controll.js,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $" */

function HelpCurrentPage()
{
	Help(document.controll.helpURL.value);
	return;
	if (document.controll.checkTarget.value == null
	  || document.controll.checkTarget.value == "") {
		return;
	}
	showTarget(document.controll.checkTarget.value);
}

function Help(url)
{
        WO = window.open(url, "HELP",
		"width=800,height=640,resizable=yes,scrollbars=yes");
	WO.focus();
}

function showTarget(url)
{
        WO = window.open(url, "",
		"width=600,height=180,resizable=yes,scrollbars=yes");
	WO.focus();
}
