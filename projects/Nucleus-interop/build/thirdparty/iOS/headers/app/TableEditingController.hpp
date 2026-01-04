#ifndef __NL_TABLEEDITINGCONTROLLER_H
#define __NL_TABLEEDITINGCONTROLLER_H

#include <app/TableController.hpp>
#include <painter/TablePainter.hpp>

#define TABLEROWCOLRESIZEGAP 20 //min height/width needed for rowColumn resize
#define TABLEICONSDISTANCE 70   // distance between table bbox and icons position

class Modification;

class TableEditingController : public TableController {
private:
    std::shared_ptr<NLShapeLayer> rowColumnResizeLayer = nullptr;
    std::shared_ptr<NLRenderLayer> swapTableLayer = nullptr;

    std::shared_ptr<NLLayer> bboxLayer = nullptr;
    std::shared_ptr<ZBBox> bbox = nullptr;

    bool enabledDynamicHeight = true;
    bool isRowColResize = false;
    bool resizeLineLayerAttached = false;
    bool tableMove = false;
    bool clickedOnRowOrColumnBar = false;
    //for row columnresize based on zoom
    size_t defaultRowColResizeGap = 0;

    graphikos::painter::GLPath rowOrColumnLinePath;

    ZEditorUtil::EditingData eventData; // table data changes

    graphikos::painter::GLPath addIconPath, deleteIconPath;
    std::shared_ptr<NLShapeLayer> highlightRemoveLayer = nullptr;
    std::shared_ptr<NLShapeLayer> indicatorLayer = nullptr;
    std::shared_ptr<NLLayer> tableIconsLayer = nullptr;
    std::shared_ptr<NLInstanceLayer> deleteIconLayer = nullptr;
    std::shared_ptr<NLShapeLayer> iconsBgLayer = nullptr;

    std::shared_ptr<TableRowColBox> tableBoxObjSwap = nullptr;
    bool dragStart = false;

public:
    struct TableSwapDetails {
        bool isRow = false;
        std::vector<size_t> possibleInsertingIndex;
        std::vector<graphikos::painter::GLRect> selectedRects;   // row or column
        std::vector<graphikos::painter::GLRect> unSelectedRects; // row or column
        graphikos::painter::GLRect moveingTableRect;             //selected table rect
        graphikos::painter::GLRect staticTableRect;              // remaining table rect
        size_t totalUnselectedRowOrColumn;
        size_t totalSelectedRowOrColumn;
        int insertingIndex = -1;
        bool isNewTable = true;
        size_t fromIndex;
        size_t toIndex;
        std::shared_ptr<com::zoho::shapes::ShapeObject> changedShapeObject = nullptr;
        graphikos::painter::Matrices currentMatrices;
        void setchangedShapeObject(com::zoho::shapes::ShapeObject* shapeobject);
        com::zoho::shapes::ShapeObject* getchangedShapeObject();
    };
    bool dataChangeTriggered = false;

    bool bboxLayerAttached = true;

    TableEditingController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties, std::shared_ptr<NLLayer> bboxLayer, std::shared_ptr<ZBBox> bbox);
    void onAttach() override;
    void onDetach() override;
    void attachTableAndTextLayer();
    bool needToRefreshLayer();
    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    std::tuple<bool, bool> isPointOnCellBorder(const graphikos::painter::GLPoint& mouse, const SkMatrix& matrix);
    void clearSelection(bool triggerEvent = false) override;
    bool setDynamicHeightWhileTyping(bool value);
    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override; // call it after composing..
    void throwDataModified(std::vector<ModifyData> dataTobeModified);

    void setDefaultCellGap(size_t gap); // for row or column resize
    bool canResize(graphikos::painter::TableLine tableLine, const SkMatrix& matrix, graphikos::painter::TablePainter& tablePainter);

    void resetTableSwap();

    void throwAddOrDeleteRowColCallback(bool isAddOp, bool isColumn, bool towardsLeft) override;
    void createIndicatorForRowOrCol(bool isCol, bool towardsLeft = true);
    void clearIndicatorLayer();
    void createIndicator(float lineWidth, float lineHeight, graphikos::painter::GLPath totalSelectedCellsPath, bool isCol, bool towardsLeft = true);
    graphikos::painter::GLPath createIndicatorTriangle(std::string position, int indicatorLineLength, graphikos::painter::GLPath totalSelectedCellsPath, bool isCol, bool towardsLeft = true);
    void highlightRemoveRowOrColLayer(bool isColDelete);
    void setConnectorController(std::shared_ptr<ConnectorController> _connectorController);
    void updateTableProperties(com::zoho::shapes::ShapeObject* shapeObject, com::zoho::shapes::Transform* mergedTransform);

    graphikos::painter::GLRect getDeleteIconRect(bool isRow, const SkMatrix& matrix);

protected:
    TableSwapDetails swapDetails;
    void disableIcons(std::shared_ptr<com::zoho::shapes::ShapeObject> iconShape);
    void renderAddAndDeleteIcons(graphikos::painter::GLRect rect);

    void deleteCellTextBodies();
    Modification getModificationForTextBodyDelete(com::zoho::shapes::TextBody* textBody);

    bool checkAndthrowDeleteRowCol(const graphikos::painter::GLPoint& point, const SkMatrix& matrix);

    graphikos::painter::GLRect renderSelectionBox() override;

    void updateTextEditor(graphikos::painter::ShapeDetails cellDetails) override;

    bool updateData(const SkMatrix& matrix);

    /**
     * below functions are used for  row col resize
     * 
     */
    std::shared_ptr<com::zoho::shapes::Stroke> lineData = nullptr;
    void createRowColResizeLine();
    bool resizeRowOrColumn(const graphikos::painter::GLPoint& startPoint, const graphikos::painter::GLPoint& endPoint, SelectedShape shape, const SkMatrix& matrix);
    std::shared_ptr<com::zoho::shapes::ShapeObject> getModifiedData(SelectedShape shape, ZEditorUtil::EditingData eventData, const SkMatrix& matrix);
    size_t getDefaultCellGap();

    /**
     * @brief bellow functions are for table swap
     * 
     */
    bool breakTable(std::vector<size_t> indices, bool row);
    bool isTableMove(std::vector<size_t> indices, bool row);
    void showRowOrColumnLine(TableSwapDetails& swapDetails, const SkMatrix& matrix);
    void updateColumnTextLayer(size_t startingAt, size_t fromColIndex, size_t totalColumns, std::shared_ptr<NLTextLayer>& textLayer);
    void updateRowTextLayer(size_t startingAt, size_t fromRowIndex, size_t totalRows, std::shared_ptr<NLTextLayer>& textLayer);
    void updateSingleRowTextLayer(size_t startingAt, size_t fromRowIndex, std::shared_ptr<NLTextLayer>& textLayer);
    void updateSingleColumnTextLayer(size_t startingAt, size_t fromColIndex, std::shared_ptr<NLTextLayer>& textLayer);
    void updateTableTransform(TableSwapDetails& swapDetails, SelectedShape shape);
    std::vector<size_t> getMovingRowOrColumnIndices(std::tuple<size_t, bool> currentRorCIndex);

    void clearTableSwapLayer();

    std::tuple<int, int> getRowMinMax();
    size_t getMinRowIndex(com::zoho::shapes::ShapeObject* shape, size_t currentIndex);
    size_t getMaxRowIndex(com::zoho::shapes::ShapeObject* shape, size_t currentIndex);

    std::tuple<int, int> getColMinMax();
    size_t getMinColIndex(com::zoho::shapes::ShapeObject* shape, size_t currentIndex);
    size_t getMaxColIndex(com::zoho::shapes::ShapeObject* shape, size_t currentIndex);

    size_t getStartAt(TableSwapDetails& swapDetails, bool isStaticTable);
};
#endif