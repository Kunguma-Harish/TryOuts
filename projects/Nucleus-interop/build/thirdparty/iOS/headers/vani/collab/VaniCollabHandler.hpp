#ifndef __NL_VANICOLLABHANDLER_H
#define __NL_VANICOLLABHANDLER_H

#include <vani/collab/VaniDeltaComposer.hpp>
#include <vani/collab/VaniDocumentRenderer.hpp>
#include <vani/VaniData.hpp>

class VaniCollabHandler {
private:
    std::shared_ptr<VaniDocumentRenderer> vaniDocumentRenderer;
public:
    VaniCollabHandler();
    VaniCollabHandler(VaniData* vaniData, BaseRenderer* renderer);
    std::shared_ptr<VaniDeltaComposer> vaniDeltaComposer;
    void composeAndRender(const std::string& deltaString, const std::string& docId);
    void reRender(std::vector<ComposedContent>& composedComponents);
};

#endif
