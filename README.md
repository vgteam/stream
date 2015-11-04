# stream

## Prereqs
Stream require a build of the latest protocol buffers library and zlib. If you have these installed,
great! Build away. Otherwise, you'll have to install them.

ZLIB should be present on any modern system and if not can be easily installed with a package manager.

The best way to install protobuf is to build it from source and install to system-level directories.
If you're building stream as part of VG, we bring it for you ;).

## compressed protobuf streams

Problematically, the protobuf parser and libraries provide no
mechanism to stream very large protobuf objects. [Several solutions exist, some
of which may be preferable](https://github.com/mafintosh/pbs).

stream.hpp (and friends in google/protobuf) enable stream processing of
protobuf data. In this format, protobuf objects are prefixed by varints that describe their
size on the wire. This enables the parser to determine object boundaries
without requiring a schema defining a meta-object that is a concatenation of
the objects we want to stream. The entire stream is optionally prefixed by a
length (varint64), which can be used in the calling context to provide feedback
to the user. The parser further allows these varint64 streams to be concatenated.

stream is used by [vg](https://github.com/ekg/vg) for data serialization.

To use stream, you can modify the example in this library to match your protobuf schema,
then modify main to include any processing functions you may want
to execute against the protobuf streams.

The stream library uses C++ `std::function`s to coordinate processing of the stream.
A stream handler is passed a function and an iostream, then it reads the iostream as if
it is a compressed protobuf stream, and applies the function it is passed to every element
in the stream.

Parallel stream handlers provide a simple mechanism for parallelization of streaming
data processing. When parallel functions are written, you must use `openmp` compiler
directives for coordination and process control (for instance, tagging output stanzas
as `#pragma omp critical` ensures proper ordering of the output.
