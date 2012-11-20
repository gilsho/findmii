## ---------------------------------------------------------------------------
## CS223B Project: Find Mii
## 
## This is the example Makefile for using C++ and OpenCV in this project
## 
## ---------------------------------------------------------------------------


OPENCV_INC_DIR=/afs/ir.stanford.edu/class/cs231a/opencv/include/
OPENCV_LIB_DIR=/afs/ir.stanford.edu/class/cs231a/opencv/lib/

PROGS = opencvexample
SRC = opencvexample.cpp

CV_LIBS = -lopencv_core  -lopencv_highgui -lopencv_contrib -lopencv_ml -lopencv_imgproc -lopencv_objdetect -lopencv_video -lopencv_nonfree -lopencv_calib3d
LIBS = $(MORE_LIBS) $(GT_LIBS) $(GTK_LIBS) $(CV_LIBS)

DEFS = -g -O2
CC = g++

CCFLAGS = -Wall $(DEFS) -I $(OPENCV_INC_DIR)
LDFLAGS = -L $(OPENCV_LIB_DIR) -L /usr/lib64/

SUFFIX = $(firstword $(suffix $(SRC)))
OBJ = $(SRC:$(SUFFIX)=.o)

# rule for making everything
all: $(OBJ) $(PROGS)

# specify how to build binaries
opencvexample: opencvexample.o $(OBJ)
	$(CC) $(CCFLAGS) $(LDFLAGS) $(OBJ) -o $@ $(LIBS)

# define compilation rule for .o files
%.o : %.cpp
	$(CC) $(CCFLAGS) -c $< -o $@

# clean
.PHONY : clean
clean:
	rm -f *.o $(PROGS) core
