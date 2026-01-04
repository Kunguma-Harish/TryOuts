#ifndef __NL_AUTOWINDOWATTACH_H
#define __NL_AUTOWINDOWATTACH_H
#include <skia-extension/GLRect.hpp>
#include <nucleus/core/ZWindow.hpp>

class AutoWindowAttach {
private:
    ZWindow* windowToRestore = nullptr;

public:
    /**
     * Attaches `attach` to current thread,
     * Optionally restores `restore` if it is not nullptr
     */
    AutoWindowAttach(ZWindow* attach, ZWindow* restore = nullptr);
    ~AutoWindowAttach();
};


#endif
