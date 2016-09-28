#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: makefile,v 1.2303 2007/04/27 07:54:39 liuyq Exp $"

RM = rm -f
CC=gcc

COMMON_DIR=../general
SETPOOL_DIR=./setpool
SETSPARE_DIR=./setspare
SETLD_DIR=./setld
SETARRAY_DIR=./setarray
CP_TARGET_DIR = /usr/ism-cli/bin

SOURCES_GENERAL=$(COMMON_DIR)/general.c
SOURCES_SETPOOL=$(wildcard $(SETPOOL_DIR)/*.c) 
SOURCES_SETSPARE=$(wildcard $(SETSPARE_DIR)/*.c) 
SOURCES_SETLD=$(wildcard $(SETLD_DIR)/*.c) 
SOURCES_SETARRAY=$(wildcard $(SETARRAY_DIR)/*.c) 


OBJS_SETPOOL=$(SOURCES_SETPOOL:.c=.o) $(SOURCES_GENERAL:.c=.o)
OBJS_SETSPARE=$(SOURCES_SETSPARE:.c=.o) $(SOURCES_GENERAL:.c=.o)
OBJS_SETLD=$(SOURCES_SETLD:.c=.o) $(SOURCES_GENERAL:.c=.o)
OBJS_SETARRAY=$(SOURCES_SETARRAY:.c=.o) $(SOURCES_GENERAL:.c=.o)
OBJS=$(OBJS_SETPOOL) $(OBJS_SETSPARE) $(OBJS_SETLD) $(OBJS_SETARRAY)


INCLUDE_API_DIR=/opt/iSMSM/include
LIB_API_DIR=/opt/iSMSM/lib

CFLAGS= -I $(INCLUDE_API_DIR) -I$(COMMON_DIR)

all: iSAsetpool iSAsetspare iSAsetarray iSAsetld
iSAsetpool: $(OBJS_SETPOOL)
	gcc -o $@ $^ -lm -L$(LIB_API_DIR) -liSMSMApi -liSMSMCfgApi -liSMSM 
iSAsetspare: $(OBJS_SETSPARE)
	gcc -o $@ $^ -lm -L$(LIB_API_DIR) -liSMSMApi -liSMSMCfgApi -liSMSM 
iSAsetld: $(OBJS_SETLD)
	gcc -o $@ $^ -lm -L$(LIB_API_DIR) -liSMSMApi -liSMSMCfgApi -liSMSM 
iSAsetarray: $(OBJS_SETARRAY)
	gcc -o $@ $^ -lm -L$(LIB_API_DIR) -liSMSMApi -liSMSMCfgApi -liSMSM 

	
clean::
	$(RM) iSAsetpool iSAsetspare iSAsetarray iSAsetld $(OBJS) 

copy::
	sudo cp iSA* $(CP_TARGET_DIR)