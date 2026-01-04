#ifndef _PROTOUTIL_H
#define _PROTOUTIL_H

#include <composer/ProtoBuilder.hpp>
class ProtoUtil {
private:
    static ProtoUtil* instance;

public:
    ProtoUtil();

    static ProtoUtil* getInstance();

    google::protobuf::Message* getMessage(std::string messageName);

    ProtoBuilder* newBuilder(std::string messageName, bool omitRootField, bool releaseForDelete = false, bool createOperations = true);

    ProtoBuilder* newBuilder(google::protobuf::Message* message, bool omitRootField, bool releaseForDelete = false, bool createOperations = true);

    ProtoBuilder* toBuilder(std::string messageName, bool omitRootField, bool releaseForDelete = false, bool createOperations = true);

    ProtoBuilder* toBuilder(google::protobuf::Message* message, bool omitRootField, bool releaseForDelete = false, bool createOperations = true);
};

#endif
