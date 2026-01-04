#pragma once

#include <painter/IProvider.hpp>

namespace com {
namespace zoho {
namespace shapes {
class PortionProps;
class TextLayerProperties;
}
}
}


namespace graphikos {
namespace painter {

class PortionPropsPainter {
   const com::zoho::shapes::PortionProps* portionProps;

public:
    PortionPropsPainter(const com::zoho::shapes::PortionProps* props);
    std::shared_ptr<com::zoho::shapes::TextLayerProperties> getMergedTextLayerProps(IProvider* provider);
    std::shared_ptr<com::zoho::shapes::PortionProps> getMergedPortionProps(IProvider* provider);
};
}
}
