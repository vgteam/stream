# stream

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
