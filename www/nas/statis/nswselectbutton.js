/*
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
*/

/* "@(#) $Id: nswselectbutton.js,v 1.1 2005/10/19 05:08:17 zhangj Exp $" */

function OnSelectAllBtn(itemList){
    
    if(itemList.length==null){
        itemList.checked=true;
    }else{
        for(var i=0;i<itemList.length;i++){
            itemList[i].checked=true;
        }
    }
}
function OnSelectAllUnsettingBtn(itemList){
    if(itemList.length==null){
        var temp=itemList.value.split("#");
        if(temp[1]=="off"){
            itemList.checked=true;
        }else{
            itemList.checked=false;
        }
    }else{
        for(var i=0;i<itemList.length;i++){
            var temp=itemList[i].value.split("#");
            if(temp[1]=="off"){
                itemList[i].checked=true;
            }else{
                itemList[i].checked=false;
            }
        }
    }
}
function OnClearAllBtn(itemList){
    if(itemList.length==null){
        itemList.checked=false;
    }else{
        for(var i=0;i<itemList.length;i++){
            itemList[i].checked=false;
        }
    }
}