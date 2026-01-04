#ifndef _VANIDATA_H
#define _VANIDATA_H

#include <vani/RemoteBoardModel.hpp>
#include <vani/cache/VaniCacheBuilder.hpp>
#include <app/NLData.hpp>
#include <painter/GL_Ptr.h>

namespace com {
namespace zoho {
namespace remoteboard {
class Project;
class Document;
class Frame;
class Details;
namespace build {
class ProjectData;
class DocumentData;
}
}
}
}

namespace com {
namespace zoho {
namespace comment {
class DocumentComment;
namespace build {
class DocumentCommentData;
}
}
}
}

class VaniData : public NLData {
    std::shared_ptr<RemoteBoardModel> model = std::make_shared<RemoteBoardModel>();
    std::shared_ptr<VaniCacheBuilder> cache = std::make_shared<VaniCacheBuilder>();

public:
    VaniData();
    VaniData(std::shared_ptr<RemoteBoardModel> model, std::shared_ptr<VaniCacheBuilder> cache);

    // Model and Cache
    std::shared_ptr<BaseModel> getModel() override;
    std::shared_ptr<NLCacheBuilder> getCache() override;

    // Project Management
    void setBytes(const uint8_t* data, const size_t len);
    GL_Ptr<com::zoho::remoteboard::Project> getProject();
    void setProject(com::zoho::remoteboard::build::ProjectData* data);
    void setProjectData(std::shared_ptr<com::zoho::remoteboard::build::ProjectData> data);
    std::string getProjectTitle();
    void updateProject(com::zoho::remoteboard::build::ProjectData* data);
    GL_Ptr<com::zoho::remoteboard::build::ProjectData> getProjectData();

    // Document Management
    com::zoho::remoteboard::Document* getDocument(const std::string& docId);
    void setDocument(const std::string& docId, com::zoho::remoteboard::Document* document);
    void setDocumentIds(std::vector<std::string> documentIds);
    void removeDocumentData(const std::string& docId);
    google::protobuf::RepeatedPtrField<std::string> getDocumentIds();
    google::protobuf::RepeatedPtrField<std::string> getDocumentTitlesFromProject();
    google::protobuf::RepeatedPtrField<std::string> getDocumentIdsFromProjectData();
    com::zoho::remoteboard::build::DocumentData* getDocumentData(const std::string& docId);

    // Frame Management
    com::zoho::remoteboard::Frame* getFrame(const std::string& frameId, const std::string& docId);
    int getFrameIndexById(const std::string& frameId, const std::string& docId);
    void setFrame(const std::string& docId, com::zoho::remoteboard::Frame* screen);
    void removeFrame(const std::string& docId, com::zoho::remoteboard::Frame* screen);
    GL_Ptr<com::zoho::remoteboard::Details> getFrameDetailsById(const std::string& frameId, const std::string& docId);
    com::zoho::remoteboard::Frame* getFrameFromId(const std::string& screenId, const std::string& docId);

    // Comment Management
    void setCommentsBytes(const uint8_t* data, const size_t len, const std::string& docId);
    com::zoho::comment::DocumentComment* getDocComment(const std::string& docId);
    void setDocumentComment(const std::string& docId, com::zoho::comment::DocumentComment* documentComment);
    void removeDocumentCommentData(const std::string& docId);
    GL_Ptr<com::zoho::comment::build::DocumentCommentData> getDocumentComments(const std::string& docId);
    GL_Ptr<com::zoho::comment::build::DocumentCommentData> getDocCommentDataByDocCommentId(const std::string& docCommentId);
    com::zoho::common::DocBaseMeta* getCommentBaseMeta(const std::string& docId);
    std::string getDocIdByDocCommentId(const std::string& docCommentId);
    void setDocComment(std::string docId, com::zoho::comment::DocumentComment* docComment);

    // Cloned project , documen, frame Management
    GL_Ptr<com::zoho::remoteboard::Project> getClonedProject();
    void setClonedDocumentData(const std::string& docId);
    GL_Ptr<com::zoho::remoteboard::build::DocumentData> getClonedDocumentData(const std::string& docId);
    GL_Ptr<com::zoho::remoteboard::Frame> getClonedFrame(const std::string& frameId);
    void clearClonedData();
    GL_Ptr<com::zoho::comment::build::DocumentCommentData> getClonedDocumentComments(const std::string& docId);
    void setClonedCommentsData(const std::string& docId);
    void clearClonedCommentsData();
    google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* getClonedFrames(const std::string& docId);

    // File and Media Information
    com::zoho::common::FileProperties* getFileInfoFromShapeId(com::zoho::shapes::ShapeObject* shapeObject, const std::string& docId);
    com::zoho::common::MediaProperties* getMediaInfoFromShapeId(com::zoho::shapes::ShapeObject* shapeObject, const std::string& docId);
    std::string getDuration(const std::string& duration);

    // Default Styles
    bool hasDefaultFill();
    com::zoho::shapes::Fill* getDefaultFill();
    com::zoho::shapes::Stroke* getDefaultStroke();
    com::zoho::shapes::Stroke* getDefaultConnectorStroke();
    com::zoho::shapes::Fill* getDefaultTextFill();
    float getDefaultTextSize();

    // Shape and Table Styles
    com::zoho::shapes::ShapeObject* getAudioPreviewShape();
    void setAudioPreviewShape(com::zoho::shapes::ShapeObject* audioFile);
    com::zoho::shapes::ShapeObject* getRemoveIcon();
    void setRemoveIcon(std::shared_ptr<com::zoho::shapes::ShapeObject> removeIconShape);
    com::zoho::remoteboard::SPStyle* getTableStyles();
    void setTableStyles(com::zoho::remoteboard::SPStyle* data);

    // Document Elements
    std::string getElementIdByIndex(com::zoho::remoteboard::Document* document, int index);
    std::string getAnchorIdByIndex(com::zoho::remoteboard::Document* document, int index);
    std::string getPictureClientKey(const com::zoho::shapes::PictureValue& picValue, const std::string& docId);
    GL_Ptr<com::zoho::remoteboard::FrameOrShape> getOrderedDocElements(const std::string& docId);
    GL_Ptr<com::zoho::remoteboard::FrameOrShape> getOrderedFrameElements(const std::string& docId, const std::string& screenId);

    // Frame and Document Data
    google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* getFrames(const std::string& docId);
    com::zoho::remoteboard::Frame* getFrame(const std::string& frameId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* frames);
    int getFrameIndexById(const std::string& frameId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* frames);

    std::map<std::string, GL_Ptr<com::zoho::comment::build::DocumentCommentData>> getDocumentCommentsDataMap();
};

#endif
