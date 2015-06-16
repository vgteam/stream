.PHONY: all clean test get-deps

CXX=g++
CXXFLAGS=-O3 -std=c++11 -fopenmp -g
LIBS=cpp/example.pb.o main.o
LIBPROTOBUF=protobuf/libprotobuf.a
INCLUDES=-I./ -Icpp -Iprotobuf/build/include
LDFLAGS=-L./ -Lprotobuf -lprotobuf -lz

all: example

$(LIBPROTOBUF): protobuf/src/google/protobuf/*cc  protobuf/src/google/protobuf/*h
	cd protobuf && mkdir -p build && ./autogen.sh && ./configure --prefix=`pwd`/build/ && $(MAKE) && $(MAKE) install
	cp protobuf/build/lib/libprotobuf.a protobuf/

cpp/example.pb.cc: cpp/example.pb.h
cpp/example.pb.h: example.proto $(LIBPROTOBUF)
	mkdir -p cpp
	protobuf/build/bin/protoc example.proto --cpp_out=cpp

cpp/example.pb.o: cpp/example.pb.h cpp/example.pb.cc
	$(CXX) $(CXXFLAGS) -c -o cpp/example.pb.o cpp/example.pb.cc $(INCLUDES)

main.o: main.cpp stream.hpp  $(LIBPROTOBUF)
	$(CXX) $(CXXFLAGS) -c -o main.o main.cpp $(INCLUDES)

example: main.cpp $(LIBPROTOBUF) $(LIBS)
	$(CXX) $(CXXFLAGS) -o example $(LIBS) $(INCLUDES) $(LDFLAGS)

clean:
	rm -rf cpp
	rm -f example
	rm -f *.o
	cd protobuf && $(MAKE) clean && rm -rf build
