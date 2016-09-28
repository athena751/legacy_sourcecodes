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

public class ExceptionConf {

    private static final String cvsid =
                       "@(#) $Id: ExceptionConf.java,v 1.1.1.1 2004/05/28 09:30:23 key Exp $";
    private Map processRuleMap = new HashMap();

    public void addProcessRule(ProcessRule pr) {
        if (pr != null) {
            processRuleMap.put(pr.getErrorCode(), pr);
        }
    }

    public ProcessRule getProcessRule(String errCode) {
        errCode = errCode.toLowerCase();
        return (ProcessRule) processRuleMap.get(errCode);
    }

    public Map getProcessRuleMap() {
        return processRuleMap;
    }
    public void addAll(ExceptionConf ec) {
        if (ec != null) {
            Map ruleMap = ec.getProcessRuleMap();
            processRuleMap.putAll(ruleMap);
        }
    }
}