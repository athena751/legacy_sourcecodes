#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: makefile,v 1.2301 2007/04/27 07:54:39 liuyq Exp $"

CFG_DIR = ./cfg
RMON_DIR = ./rmon

.PHONY: cfg rmon cfgcln rmoncln cfgcpy rmoncpy
all: cfg rmon
cfg:
	cd $(CFG_DIR);make 
rmon:
	cd $(RMON_DIR);make 
clean: cfgcln rmoncln 
cfgcln:
	cd $(CFG_DIR);make clean
rmoncln:
	cd $(RMON_DIR);make clean
copy:cfgcpy rmoncpy
cfgcpy:
	cd $(CFG_DIR);make copy
rmoncpy:
	cd $(RMON_DIR);make copy

	

	
