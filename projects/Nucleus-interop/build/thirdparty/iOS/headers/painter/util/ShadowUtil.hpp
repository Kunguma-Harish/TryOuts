#pragma once

namespace com {
namespace zoho {
namespace shapes {
class Effects_Shadow;
}
}
}

class SkPaint;

class ShadowUtil {
public:
    static SkPaint getPaint(com::zoho::shapes::Effects_Shadow* shadow);
};