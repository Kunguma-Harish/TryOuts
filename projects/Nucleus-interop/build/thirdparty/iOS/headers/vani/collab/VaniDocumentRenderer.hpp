#ifndef __NL_VANIDOCUMENTRENDERER_H
#define __NL_VANIDOCUMENTRENDERER_H

#include <app/NLDataController.hpp>
#include <app/BaseRenderer.hpp>

class VaniDocumentRenderer {
private:
    BaseRenderer* renderer;

public:
    VaniDocumentRenderer();
    VaniDocumentRenderer(BaseRenderer* renderer);
    void render(std::vector<ComposedContent> composedContents);
};

#endif
