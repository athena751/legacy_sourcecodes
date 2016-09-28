/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.base.api;

import com.nec.sydney.net.soap.*;
import java.util.*;

public class ExportRoot extends SoapResponse{
    private static final String	cvsid = "@(#) ExportRoot.java,v 1.9 2003/09/04 07:28:42 k-nishi Exp";
    
    private String path;
    private String codepage;
    private LocalDomain localdomain;
    
    /** No.1 */
    public ExportRoot(){
	path = new String();
	codepage = new String();
	localdomain = new LocalDomain();
    }

    /** No.2 */
    public void setPath(String path){
	this.path = path;
    }
    /** No.3 */
    public String getPath(){ return path;}
    /** No.4 */
    public void setCodePage(String code){ this.codepage = code; }
    /** No.5 */
    public String getCodePage(){ return codepage; }

    /** No.18 */
    public LocalDomain getLocalDomain(){ return localdomain; }
    /** No.19 */
    public void setLocalDomain(LocalDomain ld){
        localdomain = ld;
    }
    
}
