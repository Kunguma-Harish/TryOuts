#ifndef __NL_NLCOMPOSELISTENER_H
#define __NL_NLCOMPOSELISTENER_H

#include <app/NLCacheBuilder.hpp>
#include <composer/ComposeListener.hpp>

namespace com {
namespace zoho {
namespace collaboration {
class DocumentContentOperation_Component;
enum DocumentContentOperation_Component_OperationType : int;
}
}
}

class NLComposeListener : public ComposeListener {
public:
    NLComposeListener();
    static std::unordered_map<RenderOperationType, int> opPriority;

    ComposedContent currentComponentShapeCache;
    std::vector<ComposedContent> deletedComponentShapesCache = {};
    std::vector<ComposedContent> otherComponentShapesCache = {};
    std::string lastUpdatedShapeIdFromFieldString = "";
    std::vector<std::pair<int, std::string>> parentIds;
    std::function<void(std::string)>* shapeDeleteCallback = nullptr;

    RenderOperationType opToRenderOp(com::zoho::collaboration::DocumentContentOperation_Component_OperationType OpType);
    void clearCurrentComponentCache();
    void insertToCache(std::vector<ComposedContent>& src, ComposedContent& componentCache);
    void insertComponentCache(ComposedContent& componentCache);

    virtual bool checkForContainer(const std::string& fieldStr);
    virtual int getContainerIndex(const std::string& fieldStr);
    virtual void handleContainerOnContainer(const std::string& fieldStr);

    virtual void prePopulateCache(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId);
    virtual void postPopulateCache(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId);

    void preComponentCompose(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId) override;
    void onComponentCompose(google::protobuf::Message* message, const std::string& fieldStr, com::zoho::collaboration::DocumentContentOperation_Component_OperationType OpType, int index) override;
    void postComponentCompose(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId) override;
};

#endif