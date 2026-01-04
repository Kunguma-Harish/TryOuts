#pragma once

#include <painter/ZContext.hpp>

/**
 * @brief SelectionContext will hold 'selection' information
 */
struct SelectionContext : public graphikos::painter::ZContext {
private:
    SelectionContext(const SelectionContext& og) : ZContext(og) {
        this->doCheckSubShapes = og.doCheckSubShapes;
        this->selectionOffset = og.selectionOffset;
        this->getAllShapes = og.getAllShapes;
        this->includeHidden = og.includeHidden;
        this->checkBoundsAlone = og.checkBoundsAlone;
        this->checkOnlyContainer = og.checkOnlyContainer;
        this->excludeConnectors = og.excludeConnectors;
        this->includeTextBodyShape =  og.includeTextBodyShape;
        this->skipMergedLeader = og.skipMergedLeader;
        this->doCheckTextPath = og.doCheckTextPath;
    }

public:
    bool doCheckSubShapes = false;
    float selectionOffset = 0.0f;
    bool getAllShapes = false;
    bool includeHidden = false;
    bool checkBoundsAlone = false;
    bool checkOnlyContainer = false;
    bool excludeConnectors = false;
    bool includeTextBodyShape = false;
    bool skipMergedLeader = false;
    bool doCheckTextPath = true; // facilitator to consider checking over the textbody

    SelectionContext(graphikos::painter::IProvider* provider, bool doCheckSubShapes = false, graphikos::painter::GLRegion frame = graphikos::painter::GLRegion(), graphikos::painter::Matrices matrices = graphikos::painter::Matrices(), SkMatrix cameraMatrix = SkMatrix(), com::zoho::shapes::Transform* gTrans = nullptr)
        : ZContext(provider, frame, matrices, cameraMatrix, gTrans), doCheckSubShapes(doCheckSubShapes) {}
    SelectionContext(){};
    SelectionContext clone() const {
        return SelectionContext(*this);
    }
};
