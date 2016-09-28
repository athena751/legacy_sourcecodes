#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: makefile,v 1.2300 2003/11/24 00:54:30 nsadmin Exp $"

COMP_DIR = componentdisp
SETNAME_DIR = setname
STATEMON_DIR = statemon
CP_TARGET_DIR = /usr/ism-cli/bin

.PHONY: disklist refresh setname statemon all clean dlcln refreshcln setnamecln setmoncln copy
all: disklist refresh setname statemon
disklist:
	cd $(COMP_DIR);make -f makefile_comp
refresh:
	cd $(COMP_DIR);make -f makefile_refresh
setname:
	cd $(SETNAME_DIR);make -f makefile
statemon:
	cd $(STATEMON_DIR);make -f makefile
	
clean: dlcln refreshcln setnamecln setmoncln
dlcln:
	cd $(COMP_DIR);make clean -f makefile_comp
refreshcln:
	cd $(COMP_DIR);make clean -f makefile_refresh
setnamecln:
	cd $(SETNAME_DIR);make clean -f makefile
setmoncln:
	cd $(STATEMON_DIR);make clean -f makefile
copy:
	sudo cp -f $(COMP_DIR)/iSAdisklist $(CP_TARGET_DIR)
	sudo cp -f $(COMP_DIR)/iSArefreshlist $(CP_TARGET_DIR)
	sudo cp -f $(SETNAME_DIR)/iSAsetname $(CP_TARGET_DIR)
	sudo cp -f $(STATEMON_DIR)/iSAsetmon $(CP_TARGET_DIR)
