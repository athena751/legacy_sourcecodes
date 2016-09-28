/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.base;

import com.nec.sydney.atom.admin.base.*;
import java.util.*;
import java.lang.*;

public class SelectWrapper extends AbstractWrapper implements NasConstants {

    private static final String     cvsid = "@(#) $Id: SelectWrapper.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";
    private String seleOpt;

    /**Constructor.
    */
    public SelectWrapper(){
    }
    /**Constructor.
    */
    public SelectWrapper(ArrayList i_options){
        option=i_options;
    }
    /**Constructor.
    */
    public void setSelectOption(String i_seleopt){
        seleOpt=i_seleopt;
    }
    
    /**Create html code according to option list
    */
    public void genCodes(){
        ListIterator opts=option.listIterator();
        //String others=null;
        String opt=null;
        while(opts.hasNext()){
            opt=(String)opts.next();
            /*if(opt.equals(OTHER_ZONE_DIR)){
                //put "others" to the last position
                others=opt;
                continue;
            }*/
            if(opt.equals(seleOpt)){
                codes.append("<option value=\" ");//Keep the blank!
                codes.append(opt);
                codes.append("\" selected >");
                codes.append(opt);
                codes.append("</option>\n");
            }
            else{
                codes.append("<option value=\" ");//Keep the blank!
                codes.append(opt);
                codes.append("\"  >");//Keep the blank!
                codes.append(opt);
                codes.append("</option>\n");
            }
        }
            
        /*if(others!=null){
            if(others.equals(seleOpt)){
                codes.append("<option value=\" ");
                codes.append(others);
                codes.append("\" selected >");
                codes.append(others);
                codes.append("</option>\n");
            }
            else{
                codes.append("<option value=\" ");//Keep the blank!
                codes.append(others);
                codes.append("\"  >");//Keep the blank!
                codes.append(others);
                codes.append("</option>\n");
            }
        }*/            
        codes.append("\n ");
        /*    if(seleOpt.equals(DEFAULT_ZONE_DIR)){
                codes.append("<option value=\" ");
                codes.append(DEFAULT_ZONE_DIR);
                codes.append("\" selected >");
                codes.append(DEFAULT_ZONE_DIR);
                codes.append("</option>\n");
            }
            else{
                codes.append("<option value=\" ");//Keep the blank!
                codes.append(DEFAULT_ZONE_DIR);
                codes.append("\"  >");//Keep the blank!
                codes.append(DEFAULT_ZONE_DIR);
                codes.append("</option>\n");
            }*/
    }


    /**generate a HTML select option tag string
    */
    public void genNumList(int i_min,int i_max,int i_select){
        //super.clearOption();
        for (int i=i_min ; i<=i_max;i++){
            codes.append("\n <OPTION value=");
            codes.append(i);
            if(i==i_select){
                codes.append(" selected>");//Keep the blank!
                codes.append(i);
                codes.append("</OPTION>");
            }
            else{
                codes.append(" >");//Keep the blank!
                codes.append(i);
                codes.append("</OPTION>");
            }
        }
            
        codes.append("\n ");
    }
}
