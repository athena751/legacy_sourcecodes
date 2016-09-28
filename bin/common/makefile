#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: makefile,v 1.1 2005/06/10 02:48:23 liuyq Exp $"

RM = rm -f
CC=gcc

COMMON_DIR=.

SOURCES=nsgui_fsync.c
OBJS=nsgui_fsync.o

all: nsgui_fsync
nsgui_fsync: $(OBJS)
	gcc -o $@ $^
$(OBJS): $(SOURCES)

clean::
	$(RM) $(SOURCES) $(OBJS) 

