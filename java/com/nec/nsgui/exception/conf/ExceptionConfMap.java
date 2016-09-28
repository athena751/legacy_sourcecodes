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

import java.util.Map;
import java.util.HashMap;

public class ExceptionConfMap {

    private static final String cvsid =
                           "@(#) $Id: ExceptionConfMap.java,v 1.1.1.1 2004/05/28 09:30:23 key Exp $";
    private static final ExceptionConfMap m_instance = new ExceptionConfMap();
    private Map confMap = new HashMap() ;

    private ExceptionConfMap() {
    }

    public static ExceptionConfMap getInstance() {
        return m_instance;
    }

    public void addExceptionConf(String moduleName, ExceptionConf ec) {
        confMap.put(moduleName, ec);
    }

    public ExceptionConf getExceptionConf(String moduleName) {
        return (ExceptionConf) confMap.get(moduleName);
    }

}
