/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      
 */
package com.nec.nsgui.taglib.nssorttab;


public class STDataRenderAlignCenter extends STDataRender {

    public static final String cvsid =
        "@(#) $Id: STDataRenderAlignCenter.java,v 1.2 2006/10/09 01:51:42 qim Exp $";

    public String getCellRender(int rowIndex, String colName) throws Exception{

        String cellData = getCellData(rowIndex, colName);
        String label = getLabel(rowIndex, colName);

        String htmlCode = "<td align=\"center\">";
        
        if (label != null){
            htmlCode = htmlCode + label + cellData + "</label>"; 
        }else{
            htmlCode = htmlCode + cellData;
        }
           
        htmlCode = htmlCode + "</td>" ;
        
        return htmlCode;
    }
   
}