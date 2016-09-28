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

public class ArrayWrapper extends AbstractWrapper implements NasConstants {

    private static final String     cvsid = "@(#) $Id: ArrayWrapper.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";
    //int     seleOpt;    //the selected option's position in the array

    //int    arrayLength;    //the length of the array
    //StringBuffer     arrayDef;    //the array defination string
    //StringBuffer  lastArray;    //the last array defination
                    //this property is used to save the [Others] group

    //Constructor.
    public ArrayWrapper(){
    //    arrayDef=new StringBuffer();
    //    lastArray=new StringBuffer();
    //    arrayLength=0;
    //    seleOpt=0;
    }
    public ArrayWrapper(int i_num){
    //    arrayDef=new StringBuffer();
    //    lastArray=new StringBuffer();
    //    arrayLength=0;
    //    seleOpt=0;
        option=new ArrayList(i_num);
    }
    //Create script code according to option list
    public void genCodes (){
        //StringBuffer def=new StringBuffer();
        
        ListIterator opt=option.listIterator();
        boolean first=true;
        while(opt.hasNext()){
            if(first){
                codes.append("\"");
                codes.append(opt.next());
                codes.append("\"");
                first=false;
            }
            else{
            //to control the line return and to add a comma
                      codes.append("\n,\"");
                      codes.append(opt.next());
                      codes.append("\"");
                  }
              }
              
        codes.append(");\n");

        //if(dir.equals(OTHER_ZONE_DIR)){
        //    lastArray.append(def);
        //}
        //else{
        /*    arrayDef.append(TIME_ZONE_ARRAY);
            arrayDef.append("[");
            arrayDef.append(arrayLength);
            arrayDef.append("]=new ");
            arrayDef.append(TIME_ARRAY_INIT);
            arrayDef.append("(\n");
            arrayDef.append(def);
            
            arrayLength++;
        }
        */
        clearOption();         
    }
    
    //Create html code according to option list
    /*public void genCodes(){
        codes.append(TIME_ZONE_ARRAY);
        codes.append("=new Array(");
        codes.append(arrayLength+2);
        codes.append(");");
        codes.append(arrayDef);
        //the [Others] group
        codes.append(TIME_ZONE_ARRAY);
        codes.append("[");
        codes.append(arrayLength);
        codes.append("]=new ");
        codes.append(TIME_ARRAY_INIT);
        codes.append("(\n");
        codes.append(lastArray);
        //the [-----] group
        codes.append(TIME_ZONE_ARRAY);
        codes.append("[");
        codes.append(arrayLength+1);
        codes.append("]=new ");
        codes.append(TIME_ARRAY_INIT);
        codes.append("(\"");
        codes.append(DEFAULT_ZONE);
        codes.append("\");\n");

        arrayDef=new StringBuffer();
        lastArray=new StringBuffer();
        return;
    }*/
    
    //Set selected option's position
    /*public void setSelectOption(int i_seleOpt){
        seleOpt=i_seleOpt;
        return;
    }
    */
}