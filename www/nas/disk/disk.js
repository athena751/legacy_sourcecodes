/*
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: disk.js,v 1.5 2005/12/17 05:55:23 liq Exp $"
*/

/************* this js file is just for disk ***************/

function gatherlist(pdlist,formindex){
    var info = document.forms[0].elements[pdlist];
    var line = "";
    for (var i=formindex;i<info.length;i++){
	    var oneinfo = info.options[i].value; //xxh,cccc,type
		if(i>formindex){
			line=line+"#";
		}
		line = line + oneinfo;
	}
	return line;
}

function isSameTypePD(pdlist,fromindex){
    var info = document.forms[0].elements[pdlist];
    var isSame = true;
    var pdtype = (info.options[0].value).split(",")[2];
    for(var i=fromindex; i<info.length;i++){
        var tmppdtype = (info.options[i].value).split(",")[2];
        if (tmppdtype!=pdtype){
            isSame = false;
            break;
        }
    }
    return isSame;
}

