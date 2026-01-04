#ifndef __NL_VANICOMPOSELISTENER_H
#define __NL_VANICOMPOSELISTENER_H

#include <app/NLCacheBuilder.hpp>
#include <vani/VaniData.hpp>
#include <app/private/collab/NLComposeListener.hpp>
#include <regex>

struct regexPatterns {
    std::regex elementPattern = std::regex("^2,3,arr:([0-9]+)$");
    std::regex anchorInsertPattern = std::regex("^2,5,arr:([0-9]+)$");
    std::regex anchorUpdatePattern = std::regex("^2,5,arr:([0-9]+)");
    std::regex frameOnFramePattern = std::regex("^3,9,arr:([0-9]+)$");
};

class VaniComposeListener : public NLComposeListener {
public:
    regexPatterns patterns;
    VaniComposeListener(VaniData* vaniData);
    VaniData* vaniData;

    void handleElementPattern(const std::string& fieldStr, std::smatch& match, int& shapeIndex, std::string& shapeId, const std::string& docId);
    void handleAnchorPattern(const std::string& fieldStr, std::smatch& match, int& shapeIndex, std::string& shapeId, const std::string& docId, bool isUpdate);
    void handleFrameonFramePattern(const std::string& fieldStr, std::smatch& match, const std::string& frameId, int& shapeIndex, std::string& shapeId, const std::string& docId);
    void populateComponentCache(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId, bool isDeleteOp);
    void updateComponentShapesCache(ComposedContent& componentCache, const std::string& shapeId, int shapeIndex, RenderOperationType opType);

    bool checkForContainer(const std::string& fieldStr) override;
    int getContainerIndex(const std::string& fieldStr) override;
    void handleContainerOnContainer(const std::string& fieldStr) override;
    void prePopulateCache(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId) override;
    void postPopulateCache(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId) override;
};

#endif