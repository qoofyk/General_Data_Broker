########################################
#
#  IUPUI CSCI 503 -- Operating Systems
#
########################################

## Compiler, tools and options
CC      =  cc
FC      =  ftn
LINK    =  ftn
# CC      = mpicc
# FC      =  mpifort  #ftn
# LINK    =  mpifort  #ftn
OPT     =  -g -craympich-mt

ADDCFLAGS =
CCFLAGS = $(OPT)
LDFLAGS = $(OPT)

## Libraries
LIBS = -lpthread -lm
INC  = -I.

## FILES
OBJECTS = main.o do_thread.o compute_generator.o compute_sender.o compute_writer.o analysis_receiver.o analysis_reader.o analysis_writer.o analysis_consumer.o
TARGET  = lbm_concurrent_store


## Implicit rules
.SUFFIXES: .c
.c.o:
	$(CC) -c $(CCFLAGS) $(ADDCFLAGS) $(INC) $<

## Build rules
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LINK) -o $@ $(OBJECTS) $(LDFLAGS) $(LIBS)

clean:
	rm -f $(OBJECTS) $(TARGET)
	rm -f *~ core
