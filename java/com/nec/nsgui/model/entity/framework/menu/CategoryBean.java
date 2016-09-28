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
import java.util.LinkedHashMap;
import java.util.Map;

import com.nec.nsgui.model.entity.framework.FrameworkConst;

/**
 *
 */
public class CategoryBean extends MenuBaseBean implements FrameworkConst {
    private static final String cvsid =
        "@(#) $Id: CategoryBean.java,v 1.2 2004/07/14 14:06:32 het Exp $";

    private Map subCategoryMap = new LinkedHashMap();

    public CategoryBean() {

    }

    public CategoryBean(
        String msgKey,
        String detailMsgKey,
        String level,
        String machineType,
        Map subCategoryMap) {
        super(msgKey, detailMsgKey, level, machineType);
        this.subCategoryMap.putAll(subCategoryMap);
    }
    /**
     * 
     * @param item
     */
    public void addSubCategoryMap(SubCategoryBean subCategory) {
        subCategoryMap.put(
            subCategory.getMsgKey()
                + MENU_KEY_SEPARATOR
                + subCategory.getMachineType(),
            subCategory);
    }

    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (!super.equals(obj)) {
            return false;
        }
        CategoryBean category = (CategoryBean) obj;
        if (!(category.subCategoryMap.equals(subCategoryMap))) {
            return false;
        }
        return true;
    }
    /**
     * 
     * @param subCategory
     */
    public void merge(CategoryBean category) {
        Map subCategorys = category.getSubCategoryMap();
        Iterator subCategoryIt = subCategorys.keySet().iterator();
        while (subCategoryIt.hasNext()) {
            String key = (String) subCategoryIt.next();
            if (this.subCategoryMap.containsKey(key)) {
                SubCategoryBean sCategory =
                    (SubCategoryBean) (this.subCategoryMap.get(key));
                sCategory.merge((SubCategoryBean) (subCategorys.get(key)));
            } else {
                this.subCategoryMap.put(key, subCategorys.get(key));
            }
        }
    }
    /**
     * @return
     */
    public Map getSubCategoryMap() {
        return subCategoryMap;
    }

    /**
     * @param map
     */
    public void setSubCategoryMap(Map map) {
        subCategoryMap = map;
    }
    public CategoryBean getMyClone() {
        Map m = new LinkedHashMap();
        Iterator it = subCategoryMap.keySet().iterator();
        while (it.hasNext()) {
            String key = (String) it.next();
            SubCategoryBean subCategory =
                (SubCategoryBean) subCategoryMap.get(key);
            m.put(key, subCategory.getMyClone());
        }
        return new CategoryBean(
            super.getMsgKey(),
            super.getDetailMsgKey(),
            super.getLevel(),
            super.getMachineType(),
            m);
    }
}
