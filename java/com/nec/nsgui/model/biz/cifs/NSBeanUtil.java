/*
 *      Copyright (c) 2004-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.cifs;

import java.beans.PropertyDescriptor;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
/**
 *
 */
public class NSBeanUtil {
    private static final String cvsid =
        "@(#) $Id: NSBeanUtil.java,v 1.3 2009/03/30 05:00:30 chenbc Exp $";

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

    // add by jiangfx, start
    // overwrite createBeanList
    public static List createBeanList(
        String beanClazz,
        String[] valueArray)
        throws Exception {
        List retList = new ArrayList();
        if (beanClazz == null
            || beanClazz.equals("")
            || valueArray == null
            || valueArray.length == 0) {
            return retList;
        }
        
        // count line number between two blank line, include one blank line
        int propertyCount= 0 ;
        while((propertyCount < valueArray.length) 
              &&(!(valueArray[propertyCount].equals("")))) {
            propertyCount++;     
        }
        
        propertyCount++;
      
        retList = createBeanList(beanClazz, valueArray, propertyCount);
        return retList;
    }
    // add by jiangfx, end
    public static void setProperties(Object bean, String[] valueArray) throws Exception {
        setProperties(bean, valueArray, null);
    }
    /**
    *  The bean members' type is limited to String and String[]
    */
    public static void setProperties(Object bean, String[] valueArray, String delimiter)
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
                if(delimiter != null){
                    PropertyDescriptor descriptor = PropertyUtils.getPropertyDescriptor(bean, key);
                    Class propertyType = descriptor.getPropertyType();
                    if(propertyType.isArray()){
                        String[] values = tmpArray[1].split(delimiter);
                        map.put(key, values);
                        continue;
                    }
                }
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

