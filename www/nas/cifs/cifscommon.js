/**
 *       Copyright (c) 2008 NEC Corporation
 *
 *       NEC SOURCE CODE PROPRIETARY
 *
 *       Use, duplication and disclosure subject to a source code
 *       license agreement with NEC Corporation.
 *
 * "@(#) $Id: cifscommon.js,v 1.2 2008/05/15 04:42:23 chenbc Exp $"
 */
 
function utf8LengthByNFD(str){
    var tmpStr = str.replace(/[\u304c\u304e\u3050\u3052\u3054\u3056\u3058\u305a\u305c\u305e\u3060\u3062\u3065\u3067\u3069\u3070\u3071\u3073\u3074\u3076\u3077\u3079\u307a\u307c\u307d\u3094\u309e\u30ac\u30ae\u30b0\u30b2\u30b4\u30b6\u30b8\u30ba\u30bc\u30be\u30c0\u30c2\u30c5\u30c7\u30c9\u30d0\u30d1\u30d3\u30d4\u30d6\u30d7\u30d9\u30da\u30dc\u30dd\u30f4\u30f7\u30f8\u30f9\u30fa\u30fe]/g, "  ");
    return tmpStr.length;
}

function utf8LengthByNFC(str){
    var tmpStr = str.replace(/[\ud800-\udbff][\udc00-\udfff]/g, " ");
    return tmpStr.length;
}

function checkNFDLength(str, maxLength){
    return utf8LengthByNFD(str) <= maxLength;
}

function checkNFCLength(str, maxLength){
    return utf8LengthByNFC(str) <= maxLength;
}
