/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.account;

public interface StringDefine {
    public static final String cvsid =
        "@(#) StringDefine.java,v 1.1 2004/08/11 05:37:11 k-nishi Exp";
    final String TAG_SERVERS = "servers";
    final String AT_STANDALONE = "standalone";
    final String TAG_NAS = "nas";
    final String TAG_CLUSTER = "cluster";
    final String TAG_IPSAN = "ipsan";
    final String TAG_FCSAN = "fcsan";
    final String TAG_VOLUME = "volume";
    final String NASADMINISTRATOR = "NASAdministrator";
    final String IPSANADMINISTRATOR = "IPSANAdministrator";
    final String FCSANADMINISTRATOR = "FCSANAdministrator";
    final String VOLUMEADMINISTRATOR = "VOLUMEAdministrator";
    final String TAG_ADMINISTRATORS = "administrators";
    final String TAG_VOLUMES = "volumes";

    final String AT_ID = "id";
    final String AT_NICKNAME = "nickname";
    final String TAG_ADDRESS = "address";
    final String TAG_SOAP = "soap";
    final String TAG_ROUTER = "router";
    final String TAG_INFO = "info";
    final String TAG_SNMP = "snmp";
    final String TAG_SNMPUSER = "user";
    final String TAG_PORT = "port";
    final String TAG_VERSION = "version";
    final String TAG_AUTHTYPE = "authtype";
    final String TAG_AUTH = "auth";
    final String TAG_AUTHPASSPHRASE = "authpassphrase";
    final String TAG_PRIV = "priv";
    final String TAG_PRIVPASSPHRASE = "privpassphrase";
    final String TAG_NETWORK = "network";
    final String TAG_MP = "mp";
    final String TAG_INTERNALADDRESS = "internaladdress";
    final String AT_ADDRESS = "address";
    final String AT_NETMASK = "netmask";
    //    final String AT_STATUS = "status";
    final String AT_MYNODE = "mynode";
    final String AT_STATUS = AT_MYNODE;

    final String TAG_NSUSER = "user";
    final String TAG_PASSWD = "passwd";
    final String TAG_FULLNAME = "gecos";
    final String TAG_MAILADDRESS = "mail";
    final String TAG_SESSION = "max";
    final String TAG_ROLE = "role";
    final String TAG_ORGANIZATION = "organization";
    final String TAG_TEL = "tel";
    final String TAG_TARGET = "target";
    final String AT_TYPE = "type";

    final String FILE_NASESXML = "/etc/nases.xml";
    final String FILE_CPNASESXML = "/etc/cpnases.xml";
    final String FILE_NSUSERSXML = "/etc/nsusers.xml";
    final String FILE_CPNSUSERSXML = "/etc/cpnsusers.xml";

    final String XML = ".xml";
    final String LOCK_SUFFIX = ".lock";
}
