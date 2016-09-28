/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.usermapping;

import com.nec.nsgui.model.biz.usermapping.UsermappingHandler;
import com.nec.nsgui.model.biz.base.NSException;

public class UsermappingCommon {
    private static final String cvsid = "@(#) $Id: UsermappingCommon.java,v 1.3 2008/05/16 02:06:24 fengmh Exp $";
    
    public static void changeComputerName(int groupNo, 
            boolean isCluster, String domainName,
            String newComputerName, String oldComputerName,
            boolean noCheckAccess) throws Exception {//used for schedule scan's computer name change.
        changeComputerName(groupNo, isCluster, domainName, newComputerName, oldComputerName,
                noCheckAccess, true);
    }
    
    public static void changeComputerName(int groupNo, 
            boolean isCluster, String domainName,
            String newComputerName, String oldComputerName,
            boolean noCheckAccess, boolean noCheckComputerName) throws Exception {
        if(!noCheckAccess) {
            boolean hasAccess4Self = UsermappingHandler.checkAccess(groupNo, domainName, oldComputerName);
            if(hasAccess4Self){
                NSException e = new NSException();
                e.setErrorCode("0x141000030");
                throw e;
            }
            if(isCluster) {
                boolean hasAccess4Another = false;
                hasAccess4Another = UsermappingHandler.checkAccess(1-groupNo, domainName, oldComputerName);
                if(hasAccess4Another) {
                    NSException e = new NSException();
                    e.setErrorCode("0x141000030");
                    throw e;
                }
            }
        }
        if(!noCheckComputerName) {
            //check if new computer has been used in virtual_servers. 
            boolean isExist4Self = UsermappingHandler.checkComputerName(groupNo, newComputerName);
            if(isExist4Self) {
                NSException e = new NSException();
                e.setErrorCode("0x14100031");
                throw e;
            }
            if(isCluster) {
                boolean isExist4Another = false;
                isExist4Another = UsermappingHandler.checkComputerName(1-groupNo, newComputerName);
                if(isExist4Another) {
                    NSException e = new NSException();
                    e.setErrorCode("0x14100031");
                    throw e;
                }
            }
        }
        UsermappingHandler.changeNetbios(groupNo, domainName, newComputerName, oldComputerName, false);
        if(isCluster) {
            try{
                UsermappingHandler.changeNetbios(1-groupNo, domainName, newComputerName, oldComputerName, true);
            } catch (NSException e) {
                if(!e.getErrorCode().equalsIgnoreCase("0x14100008")) {
                    try{
                        UsermappingHandler.changeNetbios(groupNo, domainName, oldComputerName, newComputerName, false);
                    }catch(Exception ex) {
                    }
                }
                throw e;
            }
        }
    }
}