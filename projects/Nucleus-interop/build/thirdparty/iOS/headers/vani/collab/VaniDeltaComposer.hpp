#ifndef __NL_VANIDELTACOMPOSER_H
#define __NL_VANIDELTACOMPOSER_H

#include <app/private/collab/DeltaComposer.hpp>
#include <vani/collab/VaniComposeListener.hpp>
#include <vani/VaniData.hpp>
#include <vani/VaniRootField.hpp>

namespace com {
namespace zoho {
namespace remoteboard {
namespace build {
class ProjectData;
}
}
}
};

namespace com {
namespace zoho {
namespace remoteboard {
class Document;
class Frame;
}
}
};

namespace com {
namespace zoho {
namespace comment {
class DocumentComment;
}
}
};

class VaniDeltaComposer : public DeltaComposer {
public:
    std::shared_ptr<VaniComposeListener> vaniComposeListener;

    VaniDeltaComposer(VaniData* vaniData);
    VaniData* vaniData;

    //populates composedCaches To all Caches.
    void populateCache(const std::string& mDocId) override;
    void populate(std::vector<ComposedContent>& dest, std::vector<ComposedContent>& src, const std::string& mDocId);
    NLComposeListener* getComposeListener() override;

    std::shared_ptr<ProtoBuilder> get(int rootFieldNumber, const std::string& dbId, const std::string& docId) override;
    void put(int rootFieldNumber, const std::string& dbId, const std::string& docId, google::protobuf::Message* data) override;
    void remove(int rootFieldNumber, const std::string& dbId, const std::string& docId, google::protobuf::Message* message) override;
};

#endif