/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.framework.menu;

import java.util.Iterator;
import java.util.Map;
import java.util.LinkedHashMap;

import com.nec.nsgui.model.entity.framework.FrameworkConst;

/**
 *The root of config file.
 */
public class NSMenusBean implements FrameworkConst {

    private static final String cvsid =
        "@(#) $Id: NSMenusBean.java,v 1.2 2004/07/14 14:06:32 het Exp $";
    private Map categoryMap = new LinkedHashMap();

    public NSMenusBean() {

    }

    public NSMenusBean(Map categoryMap) {
        this.categoryMap.putAll(categoryMap);
    }
    /**
     * 
     * @param category
     */
    public void addCategoryMap(CategoryBean category) {
        categoryMap.put(
            category.getMsgKey()
                + MENU_KEY_SEPARATOR
                + category.getMachineType(),
            category);
    }
    /**
     * 
     * @param category
     */
    public void merge(NSMenusBean nsmenus) {
        Map categorys = nsmenus.getCategoryMap();
        Iterator categoryIt = categorys.keySet().iterator();
        while (categoryIt.hasNext()) {
            String key = (String) categoryIt.next();
            if (this.categoryMap.containsKey(key)) {
                CategoryBean category =
                    (CategoryBean) (this.categoryMap.get(key));
                category.merge((CategoryBean) (categorys.get(key)));
            } else {
                this.categoryMap.put(key, categorys.get(key));
            }
        }
    }
    /**
     * 
     */
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        NSMenusBean nsmenus = (NSMenusBean) obj;
        if (!(nsmenus.categoryMap.equals(categoryMap))) {
            return false;
        }
        return true;
    }

    /**
     * @return
     */
    public Map getCategoryMap() {
        return categoryMap;
    }

    /**
     * @param map
     */
    public void setCategoryMap(Map map) {
        categoryMap = map;
    }

    public NSMenusBean getMyClone() {
        Map m = new LinkedHashMap();
        Iterator it = categoryMap.keySet().iterator();
        while (it.hasNext()) {
            String key = (String) it.next();
            CategoryBean category = (CategoryBean) categoryMap.get(key);
            m.put(key, category.getMyClone());
        }
        return new NSMenusBean(m);
    }

}