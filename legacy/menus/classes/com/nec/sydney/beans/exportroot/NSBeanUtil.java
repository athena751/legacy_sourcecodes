/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.exportroot;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.beanutils.BeanUtils;

/**
 *
 */
public class NSBeanUtil {
    private static final String cvsid =
        "@(#) $Id: NSBeanUtil.java,v 1.1 2004/09/01 04:10:54 xiaocx Exp $";

    private static String KEY_VALUE_SPLITER = "=";

    public static List createBeanList(
        String beanClazz,
        String[] valueArray,
        int propertyCount)
        throws Exception {
        List retList = new ArrayList();
        if (beanClazz == null
            || beanClazz.equals("")
            || valueArray == null
            || valueArray.length == 0) {
            return retList;
        }

        for (int i = 0; i < valueArray.length; i += propertyCount) {
            String[] tmpArray = new String[propertyCount];
            for (int j = 0; j < propertyCount; j++) {
                if (valueArray.length >= i + j + 1) {
                    tmpArray[j] = valueArray[i + j];
                }
            }
            Object bean =
                NSBeanUtil
                    .class
                    .getClassLoader()
                    .loadClass(beanClazz)
                    .newInstance();
            setProperties(bean, tmpArray);
            retList.add(bean);
        }
        return retList;
    }

    public static void setProperties(Object bean, String[] valueArray)
        throws Exception {
        if (bean == null || valueArray == null || valueArray.length == 0) {
            return;
        }
        Map map = new TreeMap();
        for (int i = 0; i < valueArray.length; i++) {
            String keyAndValue = valueArray[i];
            if (keyAndValue == null
                || keyAndValue.indexOf(KEY_VALUE_SPLITER) == -1) {
                continue;
            } else {
                String[] tmpArray = valueArray[i].split(KEY_VALUE_SPLITER, 2);
                String key = tmpArray[0].trim();
                String value = tmpArray[1];
                map.put(key, value);
            }
        }
        if (map.size() > 0) {
            BeanUtils.populate(bean, map);
        }
        return;
    }

}

