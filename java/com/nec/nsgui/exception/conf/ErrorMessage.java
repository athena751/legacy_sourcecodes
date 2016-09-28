/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *
 */
package com.nec.nsgui.exception.conf;

import java.util.List;
import java.util.ArrayList;
public class ErrorMessage {

    private static final String cvsid =
                    "@(#) $Id: ErrorMessage.java,v 1.2 2004/07/09 10:39:23 wangli Exp $";
    private List argList = new ArrayList();
    private String key = "";
    private String type = "";
    private String bundle = "";

    public void addArg(String property) {
        argList.add(property);
    }
    public List getArgList() {
        return argList;
    }
    public void setKey(String string) {
        key = string;
    }
    public String getKey() {
        return key;
    }
    public void setType(String string) {
        type = string;
    }
    public String getType() {
        return type;
    }
    public void setBundle(String string) {
        bundle = string;
    }
    public String getBundle() {
        return bundle;
    }
    public boolean equals(Object ob) {
        if (ob == null){
                   return false;
                }
        boolean result = true;
        ErrorMessage em = (ErrorMessage)ob;
        
        if (!(key.equals(em.key))
            ||!(bundle.equals(em.bundle))
            ||!(type.equals(em.type))
            ||!(argList.equals(em.argList))){
             result = false;
            }
       return result;
    }

}