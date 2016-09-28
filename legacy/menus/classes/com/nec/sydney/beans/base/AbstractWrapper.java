/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.base;

import java.util.*;
/**This abstract class contains the common operations to generate the HTML tags 
from a ArrayList.
*/
public abstract class AbstractWrapper{

    private static final String     cvsid = "@(#) $Id: AbstractWrapper.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";
    protected ArrayList    option;
    protected StringBuffer    codes;
    /**Default constructor.
    */
    public AbstractWrapper(){
        codes=new StringBuffer();
        option=null;
    }

    /** Add a string to the option list.
    */
    public void addOptions (String i_opt){
        option.add(i_opt);
        return;
    }
    
    
    /**Clear the option list.
    */
    public void clearOption (){
        option.clear();
    }
    
    /**Get the HTML codes.
    */
    public String getCodes(){
        String rt=codes.toString();
        codes=new StringBuffer();
        return rt;
    }
    
    /**Abstrace methods
    Generate the codes.
    */
    public abstract void genCodes();
    
}
