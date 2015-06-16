#include <iostream>
#include <fstream>
#include <getopt.h>
#include "stream.hpp"
#include "cpp/example.pb.h"

using namespace std;

int main(int argc, char** argv) {
    Person person1;
    person1.set_name("Ralph");
    person1.set_id(42);
    person1.set_email("post please");
    Person person2;
    person2.set_name("Sal");
    person2.set_id(99929999);
    person2.set_email("morse code");
    ofstream out;
    out.open("test.stream");
    vector<Person> people = { person1, person2 };
    stream::write_buffered(out, people, 0);
    out.close();
    ifstream in;
    in.open("test.stream");
    function<void(Person&)> lambda = [](Person& p) {
        cout << p.name() << endl;
        cout << p.id() << endl;
    };
    stream::for_each(in, lambda);
    in.close();
    return 0;
}
