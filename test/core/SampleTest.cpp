#include <Sample.h>
#include <gtest/gtest.h>

namespace sample
{
namespace core
{

TEST(SampleTest, GetName)
{
    Sample hello("hello");

    ASSERT_EQ("hello", hello.get_name());
}

} // namespace core
} // namespace sample