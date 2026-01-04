#ifndef __NL_COMPOSER_H
#define __NL_COMPOSER_H

#include <composer/ProtoBuilder.hpp>
#include <composer/ComposeListener.hpp>

class Composer {
private:
    int newBuilderInitState = 0;

public:
    google::protobuf::Message* Compose(google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* contentOps, ProtoBuilder* builder);
    google::protobuf::Message* Compose(com::zoho::collaboration::DocumentContentOperation* docContentOp, ProtoBuilder* builder);
    google::protobuf::Message* Compose(std::vector<const com::zoho::collaboration::DocumentContentOperation_Component*> contentOps, ProtoBuilder* builder, ComposeListener* composeListener, const std::string& dbId, const std::string& docId);
    google::protobuf::Message* composeComponent(const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, google::protobuf::Message* message, ProtoBuilder* builder, ComposeListener* composeListener, bool& isDocumentDeleted, const std::string& dbId, const std::string& docId);

    void ComposeOperation(ProtoBuilder* builder, google::protobuf::Message* message, std::string fieldstr, const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, ComposeListener* composeListener = nullptr, int pos = -1);
    void deleteDataFromMessage(google::protobuf::Message* msg, std::map<std::string, std::string> data);

    void handleRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldstr, const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, ComposeListener* composeListener = nullptr);
    void handleMessageField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldstr, const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, ComposeListener* composeListener = nullptr);

    void mergeRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldValue, int pos);
    void addRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldValue, int pos);

    void mergeMapField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldValue, std::string keyStr);
    void addMapField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldValue, std::string keyStr);
    void addMapField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, ProtoBuilder* fieldValue, std::string keyStr);
    void deleteMapField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string keyStr);

    void mergeRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, ProtoBuilder* fieldValue, int pos);
    void addRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, ProtoBuilder* fieldValue, int pos);
    void deleteRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, int pos);
    void reorderRepeatedField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, int oldIndex, int newIndex);
    void mergeRepeatedTextBody(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, bool rootField, int pos);
    google::protobuf::Message* mergeTextBody(ProtoBuilder* builder, const google::protobuf::FieldDescriptor* field, const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, bool rootField, int pos, std::string keyStr = "");

    void handleMapField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldstr, const com::zoho::collaboration::DocumentContentOperation_Component* contentOp);
    void handlePrimitiveField(ProtoBuilder* builder, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldstr, std::string fieldValue, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType);
    std::string getPrimitiveFieldValue(const com::zoho::collaboration::DocumentContentOperation_Component* contentOp);

    void getMessageFieldValue(const com::zoho::collaboration::DocumentContentOperation_Component* contentOp, google::protobuf::Message* message);
    std::string mergeValueIfNecessary(const google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string fieldstr, std::string value);
    void hybridMerge(std::string value, google::protobuf::Message* message);
    void hybridMergeWithBinary(std::vector<uint8_t> datData, google::protobuf::Message* message);
    std::string trim(const std::string& s);

    bool releaseForDelete = false;
    bool createOperations = true;
};

#endif
