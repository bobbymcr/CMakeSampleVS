#include <SampleLib.h>
#include <Sample.h>
#include <memory>

using sample::core::Sample;

extern "C"
{
    void *SampleInit(const char *name)
    {
        return new Sample(name);
    }

    const char *SampleGetName(void *p)
    {
        return static_cast<Sample *>(p)->get_name().c_str();
    }

    void SampleDestroy(void *p)
    {
        delete static_cast<Sample*>(p);
    }
}