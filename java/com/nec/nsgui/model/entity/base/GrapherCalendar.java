/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.base;

import java.util.*;

public class GrapherCalendar extends GregorianCalendar{

    private static final String     cvsid = "@(#) $Id: GrapherCalendar.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";


    public GrapherCalendar()
    {}
    public void setMillis(long millis)
    {
        setTimeInMillis(millis);
    }
    public long getMillis(){
        return getTimeInMillis();
    }
     
}
