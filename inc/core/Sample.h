#ifndef SAMPLE_INC_SAMPLE_H
#define SAMPLE_INC_SAMPLE_H

#include <string>

namespace sample
{
namespace core
{

class Sample
{
  public:
    Sample(const std::string &name);

    const std::string &get_name() const;

  private:
    std::string name_;
};

} // namespace core
} // namespace sample

#endif