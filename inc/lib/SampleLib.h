#ifndef SAMPLE_INC_LIB_SAMPLELIB_H
#define SAMPLE_INC_LIB_SAMPLELIB_H

#include <samplelib_export.h>

extern "C"
{
    SAMPLE_LIB_EXPORT void *SampleInit(const char *name);

    SAMPLE_LIB_EXPORT const char *SampleGetName(void *p);

    SAMPLE_LIB_EXPORT void SampleDestroy(void *p);
}

#endif