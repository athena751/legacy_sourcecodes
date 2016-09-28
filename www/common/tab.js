/*
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: tab.js,v 1.7 2008/05/04 01:18:55 liuyq Exp $"
*/

var tabTXTLength   = 0;
var tabState = new Array();
var curUrl;

function changeTabState(n){
    for(var i=0;i<tabTXTLength;i++){
        tabState[i] = (i==n) ? 'selected':'unselected';
    }
}

function changeCursor(n){
    document.getElementById('div' + n).style.cursor = 
        (tabState[n]!='selected') ? 'pointer' : 'default';
}

function ontab(n,taburl){
    if ( top.TITLE.menuLock == 1 ) {
        return; //lock the tab when menu is locked.
    }
    if (tabState[n] != 'selected'){
        changeTabState(n);
        document.getElementById('img0').src= 
            '/nsadmin/images/tab/_' + tabState[0] + '.jpg';

        for (var i = 1; i < tabTXTLength; i++){
            document.getElementById('img' + i).src= 
                '/nsadmin/images/tab/' + tabState[i-1] + '_' 
                + tabState[i] + '.jpg';
        }

        document.getElementById('img' + tabTXTLength).src = 
            '/nsadmin/images/tab/' + tabState[tabTXTLength - 1] + '_.jpg';

        for (i = 0; i < tabTXTLength; i++){
            document.getElementById('tab' + i).className = tabState[i];
            document.getElementById('div' + i).className = tabState[i];
        }
        curUrl = taburl;
        setTimeout('top.ACTION.bottomframe.location = "/nsadmin/common/blank4tab.html"',1);
        changeCursor(n);
    }
}

function ontabExpGrpButtonStatus(flag){
    if(top.CONTROLL.document 
        &&top.CONTROLL.document.forms[0]
        &&top.CONTROLL.document.forms[0].exportGroup){
        top.CONTROLL.document.forms[0].exportGroup.disabled = (flag=="disable");
    }
}

function ontabNodeButtonStatus(flag){
    if(top.CONTROLL.document 
        &&top.CONTROLL.document.forms[0]
        &&top.CONTROLL.document.forms[0].changeNode){
        top.CONTROLL.document.forms[0].changeNode.disabled = (flag=="disable");
    }
}
