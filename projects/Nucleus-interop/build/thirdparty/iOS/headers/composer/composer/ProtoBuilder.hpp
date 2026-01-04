#ifndef _PROTOBUILDER_H
#define _PROTOBUILDER_H

#include <composer/RootFields.hpp>
#include <string>
#include <cstdlib>
#include <cstdint>
#include <map>
#include <vector>
namespace google {
namespace protobuf {
class Message;
class Reflection;
class FieldDescriptor;
template <typename T>
class RepeatedPtrField;

}
}
namespace com {
namespace zoho {
namespace collaboration {
class DocumentContentOperation;
class DocumentContentOperation_Component;
enum DocumentContentOperation_Component_OperationType : int;
class DocumentOperation_MutateDocument;
class DocumentOperation;
class Custom;
class DocumentContentOperation_Component_Text;
}
}
}

static inline int32_t strto32(const char* str, char** endptr, int base) {
    return static_cast<int32_t>(std::strtol(str, endptr, base));
}
static inline int64_t strto64(const char* str, char** endptr, int base) {
    return static_cast<int64_t>(std::strtoll(str, endptr, base));
}
static inline uint32_t strtou32(const char* str, char** endptr, int base) {
    return static_cast<uint32_t>(std::strtoul(str, endptr, base));
}
static inline uint64_t strtou64(const char* str, char** endptr, int base) {
    return static_cast<uint64_t>(std::strtoull(str, endptr, base));
}

class ProtoBuilder {
public:
    google::protobuf::Message* message;

    struct OperationsOrdering {
        std::string name;
        google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* components = nullptr;
    };
    std::vector<OperationsOrdering> operations;
    char rootField = '\0'; //empty std::string
    bool newBuilder;
    bool updMsg = false;
    const com::zoho::collaboration::Custom* customDataObj = nullptr;
    bool releaseForDelete = false;
    bool createOperations = true;

    void merge(google::protobuf::Message* object);
    ProtoBuilder(google::protobuf::Message* message, bool omitRootField, bool releaseForDelete = false, bool createOperations = true, bool newBuilder = false);
    ~ProtoBuilder();
    void clearDocument(const com::zoho::collaboration::Custom* custom);
    void clear(std::string fieldName, int index, std::string keyStr = "");

    google::protobuf::Message* getMessage();
    void setMessage(google::protobuf::Message*);

    std::string getMessageName(google::protobuf::Message* message);
    char getRootField();

    void customData(const com::zoho::collaboration::Custom* _customObj) {
        this->customDataObj = _customObj;
    };

    void setValue(const google::protobuf::Reflection* reflection, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string value);
    void setRepeatedValue(const google::protobuf::Reflection* reflection, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string value, int index);
    void setMapValue(const google::protobuf::Reflection* reflection, google::protobuf::Message* message, const google::protobuf::FieldDescriptor* field, std::string value, std::string keyStr);
    bool isNumberField(const google::protobuf::FieldDescriptor* field);
    void set(std::string fieldName, std::string value, int index, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, bool convertToInsertOpType, std::string keyStr = "");
    void set(std::string fieldName, ProtoBuilder* valueBuilder, int index, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, bool convertToInsertOpType, std::string keyStr = "");
    void set(std::string fieldName, google::protobuf::Message* value, int index, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, bool convertToInsertOpType, std::string keyStr = "");
    void set(std::string fieldName, google::protobuf::Message* value, int index, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, bool convertToInsertOpType, google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* oprs, bool valueNewBuilder = false, std::string keyStr = "");
    void add(std::string fieldName, ProtoBuilder* value, int index, std::string keyStr = "");
    void add(std::string fieldName, std::string value, int index, std::string keyStr = "");
    google::protobuf::Message* getSubMessage(std::string fieldName);
    google::protobuf::Message* getRepeatedMessage(std::string fieldName, int index);
    std::string* getString(std::string fieldName, int index);

    void text(std::string fieldName, const google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component_Text>* texts, int pos);
    void custom(google::protobuf::Message* customData, google::protobuf::Message* oldValue);
    void reorder(std::string fieldName, int oldIndex, int newIndex);

    void createReorderOperation(const google::protobuf::FieldDescriptor* field, int oldIndex, int newIndex);

    void createOperation(com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, const google::protobuf::FieldDescriptor* field, int index, google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* operations, com::zoho::collaboration::DocumentContentOperation_Component* opr, std::string* value = nullptr, std::string* oldValue = nullptr, std::string* deleteData = nullptr, const google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component_Text>* texts = nullptr, std::string keyStr = ""); //for  primitive type
    std::string* getRepeatedValue(const google::protobuf::Reflection* reflection, const google::protobuf::FieldDescriptor* field, int index);
    std::string* getPrimitiveValue(const google::protobuf::Reflection* reflection, const google::protobuf::FieldDescriptor* field);
    std::string* getMapValue(const google::protobuf::Reflection* reflection, const google::protobuf::FieldDescriptor* field, std::string keyStr);
    void deleteRepeatedValue(const google::protobuf::Reflection* reflection, const google::protobuf::FieldDescriptor* field, int index);
    void updateMessage(bool _updMsg) {
        this->updMsg = _updMsg;
    };

    void constructOperation(com::zoho::collaboration::DocumentContentOperation_Component* opr, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, std::string fields, std::string* value = nullptr, std::string* oldValue = nullptr, std::string* deleteData = nullptr, const com::zoho::collaboration::Custom* customObj = nullptr);
    void constructTextOperation(com::zoho::collaboration::DocumentContentOperation_Component* opr, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, std::string fields, const google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component_Text>* texts);
    void constructReorderOperation(com::zoho::collaboration::DocumentContentOperation_Component* opr, com::zoho::collaboration::DocumentContentOperation_Component_OperationType opType, std::string fields, int newIndex);

    std::string getFields(const google::protobuf::FieldDescriptor* field, int index, char rootField, std::string keyStr = "");

    google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* toOperations();

    com::zoho::collaboration::DocumentOperation_MutateDocument* toDocOp(std::string mDocId, google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* oprs);
    void printOperations();

    void insertToOperations(OperationsOrdering& toOp);
    static int hasMapEntry(google::protobuf::Message* message, const google::protobuf::Reflection* reflection, const google::protobuf::FieldDescriptor* field, std::string keyStr);
};

#endif
