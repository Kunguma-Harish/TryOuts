#ifndef __NL_COMPOSELISTENER_H
#define __NL_COMPOSELISTENER_H

#include <iostream>
#include <string>

namespace google {
namespace protobuf {
class Message;
}
};

namespace com {
namespace zoho {
namespace collaboration {
class DocumentContentOperation_Component;
enum DocumentContentOperation_Component_OperationType : int;
}
}
};

class ComposeListener {
public:
    virtual void preComponentCompose(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId);
    virtual void onComponentCompose(google::protobuf::Message* message, const std::string& fieldStr, com::zoho::collaboration::DocumentContentOperation_Component_OperationType OpType, int index);
    virtual void postComponentCompose(const com::zoho::collaboration::DocumentContentOperation_Component* component, const std::string& dbId, const std::string& docId);
};

#endif