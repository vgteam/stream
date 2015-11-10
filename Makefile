.PHONY: all clean test get-deps pre

CXX=g++
CXXFLAGS=-O3 -std=c++11 -fopenmp -g

CPP_DIR:=cpp
BIN_DIR:=bin
SRC_DIR:=src
LIB_DIR:=lib
OBJ_DIR:=obj
INC_DIR:=include
PROTO_PATH:=


INCLUDES=-I./ -Isrc -Iobj -Icpp -I/usr/local/include -I/usr/local/include/google/protobuf/
LD_LIB_FLAGS=-L./ -L/usr/local/lib/ -lprotobuf -lz


all: $(BIN_DIR)/example

# Assume a global copy of PB3 is available
#$(LIBPROTOBUF):
#	cd protobuf && mkdir -p build && ./autogen.sh && ./configure --prefix=`pwd`/build/ && $(MAKE) && $(MAKE) install
#	cp protobuf/build/lib/libprotobuf.a protobuf/

$(CPP_DIR)/example.pb.cc: $(CPP_DIR)/example.pb.h pre
$(CPP_DIR)/example.pb.h: $(SRC_DIR)/example.proto pre
	protoc --proto_path=$(SRC_DIR) --cpp_out=$(CPP_DIR) $< 

$(CPP_DIR)/example.pb.o: $(CPP_DIR)/example.pb.h $(CPP_DIR)/example.pb.cc pre
	$(CXX) $(CXXFLAGS) -c -o $(CPP_DIR)/example.pb.o $(CPP_DIR)/example.pb.cc $(INCLUDES)

$(OBJ_DIR)/main.o: $(SRC_DIR)/main.cpp $(SRC_DIR)/stream.hpp $(CPP_DIR)/example.pb.h pre
	$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCLUDES) $(LD_LIB_FLAGS)

$(BIN_DIR)/example: $(SRC_DIR)/main.cpp $(OBJ_DIR)/main.o $(CPP_DIR)/example.pb.o pre
	$(CXX) $(CXXFLAGS) -o $@ $(CPP_DIR)/example.pb.o $(OBJ_DIR)/main.o $(INCLUDES) $(LD_LIB_FLAGS)

pre:
	if [ ! -d $(BIN_DIR) ]; then mkdir -p $(BIN_DIR); fi
	if [ ! -d $(CPP_DIR) ]; then mkdir -p $(CPP_DIR); fi
	if [ ! -d $(LIB_DIR) ]; then mkdir -p $(LIB_DIR); fi
	if [ ! -d $(OBJ_DIR) ]; then mkdir -p $(OBJ_DIR); fi
	if [ ! -d $(INC_DIR) ]; then mkdir -p $(INC_DIR); fi

clobber: clean
	rm -rf bin
	rm -rf lib
	rm -rf cpp
	rm -rf obj
clean:
	rm -rf cpp
	rm -f example
	rm -f *.o
	rm -f test.stream
