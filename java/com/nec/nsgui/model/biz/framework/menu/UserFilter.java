package com.nec.nsgui.model.biz.framework.menu;

import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.menu.ItemBean;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;

public class UserFilter implements Filter, FrameworkConst {
    private String currUser = "";

    private static String NSVIEW = "nsview";

    private static String REF_SUFFIX = ".ref";

    private static String NSVIEW_PAGE_NOT_FOUND = "nsviewnotfound.html";
    
    public UserFilter(String user) throws Exception {
        if (user == null || user.equals("")) {
            throw new Exception("must specify the user.");
        }
        currUser = user;
    }

    public MenuBaseBean filter(MenuBaseBean nsmenu) {
        if (!(nsmenu instanceof ItemBean)) {
            return nsmenu;
        }
        ItemBean tmpBean = (ItemBean) nsmenu;
        if (tmpBean.getUserType().indexOf(currUser) < 0) {
            return null;
        }
        if (currUser.equals(NSVIEW)) {
            tmpBean.setDetailMsgKey(tmpBean.getDetailMsgKey() + REF_SUFFIX);
            if (tmpBean.getRefHref() != null
                    && !tmpBean.getRefHref().equals("")) {
                tmpBean.setHref(tmpBean.getRefHref());
            }else{
                tmpBean.setHref(NSVIEW_PAGE_NOT_FOUND);
            }
        }
        return tmpBean;
    }

}
