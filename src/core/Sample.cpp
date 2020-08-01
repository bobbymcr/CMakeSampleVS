#include <Sample.h>

namespace sample
{
namespace core
{

Sample::Sample(const std::string &name) : name_(name)
{
}

const std::string &Sample::get_name() const
{
    return name_;
}

} // namespace core
} // namespace sample