#include <iostream>
#include <memory>
#include <SampleLib.h>

using std::cout;
using std::endl;
using std::unique_ptr;

int main(int argc, const char *argv[])
{
    if (argc != 2)
    {
        cout << "Please pass a string!" << endl;
        return 1;
    }

    unique_ptr<void, void(*)(void*)> p(SampleInit(argv[1]), &SampleDestroy);
    cout << "Hello, " << SampleGetName(p.get()) << "!" << endl;
    return 0;
}