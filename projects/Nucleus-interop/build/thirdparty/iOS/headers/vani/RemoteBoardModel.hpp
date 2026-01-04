#ifndef __NL_REMOTEBOARDMODEL_H
#define __NL_REMOTEBOARDMODEL_H

#include <painter/GL_Ptr.h>
#include <painter/ShapeObjectPainter.hpp>
#include <app/BaseModel.hpp>

#include <map>

namespace com {
namespace zoho {
namespace comment {
class DocumentComment;
namespace build {
class DocumentCommentData;
}
}
namespace remoteboard {
class Details;
class FrameOrShape;
class SPStyle;
class Document;
class Frame;
class Project;
class Document_ScreenOrShapeElement;
namespace build {
class ProjectData;
class DocumentData;
}
}
namespace shapes {
class Stroke;
class ShapeObject;
class ShapeObject_CombinedObject_CombinedNode;
}
namespace common {
class BaseMeta;
class DocBaseMeta;
class Dimension;
class MediaProperties;
class FileProperties;
class MediaAssociation;
class FileAssociation;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

class RemoteBoardModel: public BaseModel  {
public:
    RemoteBoardModel();
    ~RemoteBoardModel();
    GL_Ptr<com::zoho::remoteboard::build::ProjectData> projectData = nullptr;
    GL_Ptr<com::zoho::remoteboard::Project> project = nullptr;
    GL_Ptr<com::zoho::remoteboard::SPStyle> tableStyles = nullptr;
    GL_Ptr<com::zoho::shapes::ShapeObject> audioFilePreview = nullptr;
    GL_Ptr<com::zoho::shapes::ShapeObject> removeIcon = nullptr;

    std::map<std::string, GL_Ptr<com::zoho::comment::build::DocumentCommentData>> docCommentDatasMap; //key: docCommentId , value: DocumentCommentData docCommentData

    std::string projectDataName;
    std::string deserializationTimeTaken;
    int projectDataSizeInKB;
    int deserializedProjectData;

    //for clones of project data and its components
    GL_Ptr<com::zoho::remoteboard::Project> cloned_Project;
    GL_Ptr<com::zoho::remoteboard::build::DocumentData> cloned_DocumentData;
    GL_Ptr<com::zoho::remoteboard::Document> cloned_Document;
    GL_Ptr<google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>> clonedFrames = nullptr;

    std::pair<std::string, GL_Ptr<com::zoho::comment::build::DocumentCommentData>> cloned_CommentsData; //there is no documentId in DocumentCommentData so we are using pair to store docId and DocumentCommentData

    std::map<std::string, GL_Ptr<com::zoho::remoteboard::Frame>> cloned_DataMap;

    GL_Ptr<com::zoho::remoteboard::Project> getClonedProject();
    void setClonedDocumentData(const std::string& docId);

    GL_Ptr<com::zoho::remoteboard::build::DocumentData> getClonedDocumentData(const std::string& docId);
    GL_Ptr<com::zoho::remoteboard::Frame> getClonedFrame(const std::string& frameId);
    void clearClonedData();
    void clearClonedCommentsData();
    void removeDocumentCommentData(std::string docId);

    google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* getClonedFrames(std::string docId);
    com::zoho::remoteboard::Details* getClonedFrameDetailsById(std::string id, std::string docId);

    void setTableStyles(com::zoho::remoteboard::SPStyle* data);
    void setRemoveIcon(std::shared_ptr<com::zoho::shapes::ShapeObject> removeIconShape);

    void setAudioPreviewShape(com::zoho::shapes::ShapeObject* audioFile);
    com::zoho::shapes::ShapeObject* getAudioPreviewShape();
    com::zoho::shapes::ShapeObject* getRemoveIcon();

    GL_Ptr<com::zoho::remoteboard::build::ProjectData> getProjectData();
    std::string getProjectTitle();
    com::zoho::remoteboard::SPStyle* getTableStyles();

    std::string getDocIdByDocCommentId(std::string docCommentId);

    com::zoho::comment::DocumentComment* getDocComment(std::string docId) ;
    GL_Ptr<com::zoho::comment::build::DocumentCommentData> getDocumentComments(std::string docId);
    GL_Ptr<com::zoho::comment::build::DocumentCommentData> getClonedDocumentComments(std::string docId);
    void setClonedCommentsData(const std::string& docId);
    GL_Ptr<com::zoho::comment::build::DocumentCommentData> getDocCommentDataByDocCommentId(std::string docCommentId);
    com::zoho::common::DocBaseMeta* getCommentBaseMeta(std::string docId);
    void setCommentsBytes(const uint8_t* data, const size_t len, std::string docId);
    void setDocumentComment(std::string docId, com::zoho::comment::DocumentComment* documentComment);
    void setDocComment(std::string docId, com::zoho::comment::DocumentComment* docComment) ;

    void setBytes(const uint8_t* data, const size_t len);
    void set(GL_Ptr<com::zoho::remoteboard::build::ProjectData> data);
    void setDocument(std::string docId, com::zoho::remoteboard::Document* document) ;
    void setDocumentData(std::string docId, com::zoho::remoteboard::build::DocumentData* documentData);
    void setFrame(std::string docId, com::zoho::remoteboard::Frame* screen) ;
    com::zoho::remoteboard::Frame* getFrame(const std::string& frameId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* frames);
    int getFrameIndexById(const std::string& frameId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* frames);
    com::zoho::remoteboard::Frame* getFrame(const std::string& frameId, std::string docId) ;
    int getFrameIndexById(std::string frameId, std::string docId) ;

    std::string getShapeIdByType(com::zoho::shapes::ShapeObject* shapeObject);

    com::zoho::remoteboard::Document* getDocument(std::string docId) ;
    com::zoho::remoteboard::build::DocumentData* getDocumentData(std::string docId);
    // DocBaseMeta* getDocumentBaseMeta(std::string docId);
    google::protobuf::RepeatedPtrField<std::string> getDocumentIdsFromProjectData();

    google::protobuf::RepeatedPtrField<std::string> getDocumentIds(const com::zoho::remoteboard::build::ProjectData& projectData); //used for machine build project load.
    google::protobuf::RepeatedPtrField<std::string> getDocumentIds();
    google::protobuf::RepeatedPtrField<std::string> getDocumentTitlesFromProject();
    google::protobuf::RepeatedPtrField<std::string> getDocumentTitles(const com::zoho::remoteboard::build::ProjectData& projectData);

    // google::protobuf::RepeatedPtrField<SmartDocument>* getSmartDocuments(com::zoho::remoteboard::build::ProjectData* projectData);

    com::zoho::common::BaseMeta* getProjectBaseMeta();
    std::string getElementIdByIndex(com::zoho::remoteboard::Document* document, int index) ;
    std::string getAnchorIdByIndex(com::zoho::remoteboard::Document* document, int index) ;
    google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* getFrames(std::string docId);

    GL_Ptr<com::zoho::remoteboard::Details> getFrameDetails(std::string id, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Frame>* screens);
    GL_Ptr<com::zoho::remoteboard::Details> getFrameDetailsById(std::string id, std::string docId) ;
    void removeFrame(std::string docId, com::zoho::remoteboard::Frame* screen) ;
    void removeDocumentData(std::string docId) ;
    com::zoho::remoteboard::Details* getFrameDetailsByShapeId(std::string shapeId, std::string docId);
    com::zoho::common::Dimension* getFrameDimension(std::string screenId, std::string docId);
    com::zoho::shapes::Transform* getFrameTransform(std::string screenId, std::string docId);
    bool hasFrames(std::string docId);
    bool hasFrame(std::string id, std::string docId);
    std::string getFrameId(std::string shapeId, std::string screenId);
    com::zoho::remoteboard::Details* getShapeDetails(std::string id, google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes);

    com::zoho::remoteboard::Details* compareShapeId(std::string shapeId, int index, com::zoho::shapes::ShapeObject* shapeObject, std::string parentId);
    com::zoho::remoteboard::Details* getShapeDetailsById(std::string id, std::string docId);
    com::zoho::remoteboard::Details* _traverseShapes(std::string idToCompare, int index, com::zoho::shapes::ShapeObject* shapeObject, std::string parentId);
    com::zoho::remoteboard::Details* traverseShapes(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject>* shapes, std::string idToCompare, std::string parentId);
    com::zoho::remoteboard::Details* traverseCombinedShapes(google::protobuf::RepeatedPtrField<com::zoho::shapes::ShapeObject_CombinedObject_CombinedNode>* nodes, std::string idToCompare, std::string parentId);
    GL_Ptr<com::zoho::remoteboard::Project> getProject() ;
    void setDocumentIds(std::vector<std::string> documentIds);
    void setProjectData(std::shared_ptr<com::zoho::remoteboard::build::ProjectData> data);
    void setProject(com::zoho::remoteboard::build::ProjectData* data) ;
    // google::protobuf::RepeatedPtrField<com::zoho::remoteboard::DocumentStyle>* getDocStyles();

    // com::zoho::remoteboard::Details* getSpotDetails(std::string id, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Spot>* spots);
    // com::zoho::remoteboard::Details* getSpotDetailsById(std::string id, std::string screenId, std::string docId);
    // com::zoho::remoteboard::Details* getSpotgraphikos::painter::ShapeDetails(std::string shpId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Spot>* spots, std::string screenId, std::string docId);
    com::zoho::remoteboard::Details* getFrameShapeDetailsById(std::string id, std::string screenId, std::string docId);

    // com::zoho::remoteboard::Details* getSpotResponseDetails(std::string responseId, com::zoho::remoteboard::Spot* spotData);
    // com::zoho::remoteboard::Details* getSpotResponseDetailsById(std::string responseId, std::string screenId);

    // com::zoho::remoteboard::Details* getAssociatedSpotDetails(std::string shapeId, std::string screenId, std::string docId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Spot>* spots);

    //    google::protobuf::RepeatedPtrField<SmartDocument>* getSmartDocumentsFromProject();
    //    std::string getSmartDocId(std::string docId);
    bool hasShapesInFrame(std::string id, std::string docId);

    std::string getDocumentAuthor(std::string docId);
    int getDocumentCurrentVersion(std::string docId);
    bool isDocumentPublished(std::string docId);
    std::string getDocumentCollaborationId(std::string docId);
    bool hasShapeInDocument(std::string id, std::string docId);

    google::protobuf::RepeatedPtrField<std::string>* DocumentIdsFromProject();
    int getProjectCurrentVersion();
    std::string getProjectCollaborationId();
    // google::protobuf::RepeatedPtrField<com::zoho::remoteboard::DocumentStyle>* getDocumentStyles();

    com::zoho::remoteboard::Details* getDocumentShapeDetails(std::string id, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Document_ScreenOrShapeElement>* elements);
    com::zoho::remoteboard::Details* getDocumentShapeDetailsById(std::string id, std::string docId);

    GL_Ptr<com::zoho::remoteboard::FrameOrShape> getOrderedDocElements(std::string docId);
    GL_Ptr<com::zoho::remoteboard::FrameOrShape> getOrderedFrameElements(std::string docId, std::string screenId);
    int getOrderedDocElementIndex(std::string id, std::string docId);

    com::zoho::remoteboard::Details* getFrameDetailsByIndex(int index, std::string docId);
    // com::zoho::remoteboard::Details* getSpotDetailsByShapeId(std::string shpId, std::string screenId, std::string docId);
    // com::zoho::remoteboard::Details* getAssociatedSpotDetailsByShapeId(std::string shapeId, std::string screenId, std::string docId, google::protobuf::RepeatedPtrField<com::zoho::remoteboard::Spot>* spots);

    com::zoho::remoteboard::Details* getRelationShipDetails(std::string id, std::string type, std::string lookUpKey, std::string docId);
    com::zoho::remoteboard::Details* getRelationShipDetailsById(std::string id, std::string type, std::string docId);
    com::zoho::remoteboard::Details* getRelationShipDetailsByKey(std::string key, std::string type, std::string docId);
    std::string getRelationShipIdByKey(std::string key, std::string type, std::string docId);

    void updateProject(com::zoho::remoteboard::build::ProjectData* data);
    void updateFrame(com::zoho::remoteboard::build::ProjectData* data);
    void updateFrameData(google::protobuf::RepeatedPtrField<com::zoho::remoteboard::build::DocumentData>* docDatas);

    void updateProjectData(com::zoho::remoteboard::build::ProjectData* data);
    void updateDocumentData(com::zoho::remoteboard::build::DocumentData* oldDoc, com::zoho::remoteboard::build::DocumentData* newDoc);

    std::string getPictureClientKey(const com::zoho::shapes::PictureValue& picValue, std::string docId);
    std::vector<std::string> getPictureClientKeys(std::string docId);


    com::zoho::remoteboard::Frame* getFrameFromId(std::string screenId, std::string docId);

    com::zoho::common::MediaProperties* getMediaInfoFromShapeId(com::zoho::shapes::ShapeObject* shapeObject, std::string docId);
    com::zoho::common::FileProperties* getFileInfoFromShapeId(com::zoho::shapes::ShapeObject* shapeObject, std::string docId);
    std::string getClientKeyFromShape(com::zoho::shapes::ShapeObject* shapeObject, std::string docId);
    std::string getValueId(com::zoho::shapes::ShapeObject* shapeObject);
    std::string getClientKeyFromMediaAssociation(std::string id, google::protobuf::RepeatedPtrField<com::zoho::common::MediaAssociation>* mediaAssociations);
    std::string getClientKeyFromFileAssociation(std::string id, google::protobuf::RepeatedPtrField<com::zoho::common::FileAssociation>* fileAssociations);
    std::string getDuration(std::string duration);

    com::zoho::shapes::ShapeObject* getLeaderShape(std::string shapeId, std::string documentId);
    bool hasDefaultFill();
    com::zoho::shapes::Fill* getDefaultFill();
    com::zoho::shapes::Stroke* getDefaultStroke();
    com::zoho::shapes::Stroke* getDefaultConnectorStroke();
    com::zoho::shapes::Fill* getDefaultTextFill();
    float getDefaultTextSize();
};

#endif
