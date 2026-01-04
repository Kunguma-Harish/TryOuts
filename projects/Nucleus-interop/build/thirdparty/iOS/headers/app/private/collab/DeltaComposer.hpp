#ifndef __NLDELTACOMPOSER_H
#define __NLDELTACOMPOSER_H

#include <app/private/collab/NLComposeListener.hpp>
#include <composer/Composer.hpp>

class ProtoBuilder;

namespace google {
namespace protobuf {
class Message;
}
};

namespace com {
namespace zoho {
namespace collaboration {
class DocumentDelta;
class DocumentOperation;
class DocumentContentOperation_Component;
enum DocumentContentOperation_Component_OperationType : int;
}
}
};

class DeltaComposer {
public:
    DeltaComposer();
    Composer composer;

    //split mDocId at delimiter
    std::vector<std::string> parseMDocId(const std::string& input, char delimiter);

    // vector of composedContents
    std::vector<ComposedContent> deletedComposeContents = {};
    std::vector<ComposedContent> otherComposeContents = {};

    virtual std::shared_ptr<ProtoBuilder> get(int rootFieldNumber, const std::string& dbId, const std::string& docId);
    virtual void put(int rootFieldNumber, const std::string& dbId, const std::string& docId, google::protobuf::Message* data);
    virtual void remove(int rootFieldNumber, const std::string& dbId, const std::string& docId, google::protobuf::Message* data);
    virtual void populateCache(const std::string& mDocId);
    virtual NLComposeListener* getComposeListener();

    //group operations based on mDocId
    void groupOperations(const google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentOperation>& docOps, std::unordered_map<std::string, std::vector<const com::zoho::collaboration::DocumentContentOperation_Component*>>& groupedOprs);
    void composeOperations(const google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentOperation>& docOps, const std::string& docId);
    google::protobuf::Message* compose(std::vector<const com::zoho::collaboration::DocumentContentOperation_Component*> contentOps, ProtoBuilder* builder, const std::string& dbId, const std::string& docId);
};

#endif