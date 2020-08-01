#include <iostream>
#include <Sample.h>

using sample::core::Sample;
using std::cout;
using std::endl;

int main(int argc, const char *argv[])
{
    if (argc != 2)
    {
        cout << "Please pass a string!" << endl;
        return 1;
    }

    Sample world(argv[1]);
    cout << "Hello, " << world.get_name() << "!" << endl;
    return 1;
}