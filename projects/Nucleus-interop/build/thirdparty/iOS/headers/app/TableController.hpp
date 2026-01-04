#ifndef __NL_TABLECONTROLLER_H
#define __NL_TABLECONTROLLER_H

#include <app/controllers/NLEventController.hpp>
#include <skia-extension/GLRect.hpp>
#include <painter/ShapeObjectPainter.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <nucleus/core/layers/NLShapeLayer.hpp>
#include <app/ZSelectionHandler.hpp>
#include <app/TextEditorController.hpp>
#include <nucleus/core/layers/NLTextLayer.hpp>

#define ROWCOLBOXDISTANCE 40 // distance between row/column box and table

class TableController : public NLEventController {
protected:
    struct TableRowColBox {
        std::shared_ptr<NLLayer> tableRowColBoxLayer = nullptr;       // parent layer that holds fill, stroke, hover and text layers
        std::shared_ptr<NLShapeLayer> rowColBoxFillLayer = nullptr;   // holds the fill property of row, column box
        std::shared_ptr<NLShapeLayer> rowColBoxHoverLayer = nullptr;  // holds the row, column highlight if any cell(s) is selected.
        std::shared_ptr<NLShapeLayer> rowColBoxStrokeLayer = nullptr; // holds the stroke property of row, column box
        std::shared_ptr<NLTextLayer> rowColBoxTextLayer = nullptr;    // holds the text that is drawn inside row, column box

        TableRowColBox(NLDataController* dataController);
        ~TableRowColBox();
    };

    NLEditorProperties* editorProperties = nullptr;
    NLDataController* dataHandler = nullptr;
    std::shared_ptr<NLShapeLayer> cellBoxLayer = nullptr;
    std::shared_ptr<NLShapeLayer> cellLayer = nullptr;

    std::shared_ptr<TextEditorController> textEditor = nullptr; // create when needed
    CellDetails lastSelectedCell, firstSelectedCell;            // just for caching fst and last cell index since the selected cell array will be ascending order
    graphikos::painter::GLPath path;                            // check during handleover (handle drag)

    std::string rowColHoveredShapeId = ""; // this contains the currently hovered table icons/row-column box shapeId
    std::shared_ptr<TableRowColBox> tableBoxObj = nullptr;

    std::shared_ptr<ConnectorController> connectorController;

    bool rowSelect = false;
    bool colSelect = false;
    bool dragOnCell = false;
    bool textEditMode = false;
    bool triggerRerenderRegion = false;
    bool textLayerAttached = false;
    bool tableEditingLayerAttached = false;

    std::string tableId = "";
    std::vector<CellDetails> selectCells(const graphikos::painter::GLPoint& endPoint);
    bool dragOnCells(std::vector<graphikos::painter::ShapeDetails> multiCell);
    void dragEnd(const graphikos::painter::GLPoint& endPoint);
    std::vector<graphikos::painter::ShapeDetails> getMultiCellDetails(const graphikos::painter::GLPoint& endPoint);
    void multiSelectCell(graphikos::painter::ShapeDetails shapeDetails);
    int getNoOfCellSelected();

    bool isSelected(int rowIndex, int colIndex);
    virtual graphikos::painter::GLRect renderSelectionBox();
    graphikos::painter::GLRect renderCellSelectionBox(graphikos::painter::GLPath path);
    void updateRowAndColBox(graphikos::painter::GLRect rect);

    bool mouseInsideTable(const graphikos::painter::GLPoint& point);

    void selectRow(int index, bool triggerEvent = true);
    void selectCol(int index, bool triggerEvent = true);
    graphikos::painter::GLPath getPathFromSelectedCells();

    void refreshTableLayer();

private:
    bool onMouseEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix, int clickcount);

public:
    TableController(NLDataController* dataController, ZSelectionHandler* selectionHandler, ControllerProperties* properties, NLEditorProperties* editorProperties);

    enum Direction {

        LEFT = 0,
        UP = 1,
        RIGHT = 2,
        DOWN = 3

    };

    void clear();
    virtual void clearSelection(bool triggerEvent = false);
    void selectCell(graphikos::painter::ShapeDetails& shapeDetails, bool triggerEvent);
    std::vector<CellDetails>& getSelectedCells();
    void setRowColIndex(int rowIndex, int cellIndex);

    void onAttach() override;
    void onDetach() override;
    void setTableEditingLayerAttached(bool tableEditingLayerAttached);
    bool getTableEditingLayerAttached();

    bool onMouseDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDrag(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLPoint& prevPoint, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onMouseUp(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClick(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onDoubleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onTripleClickEnd(const graphikos::painter::GLPoint& start, const graphikos::painter::GLPoint& end, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onKeyDown(int keyCode, int modifier, bool repeat, std::string keyCharacter, const SkMatrix& matrix) override;
    bool onMouseMove(const graphikos::painter::GLPoint& mouse, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;
    bool onRightClickDown(const graphikos::painter::GLPoint& point, const graphikos::painter::GLRect& frame, int modifier, const SkMatrix& matrix) override;

    void selectRowOrColumn(std::string shapeId, bool isShiftKeyPressed = false);
    void selectRowOrColumnByIndex(int startIndex, int endIndex, bool isRow);
    std::tuple<size_t, bool> getRowOrColumn(std::string shapeId); // index , isRow

    graphikos::painter::ShapeDetails getNextCell(Direction key, bool shift = false, bool isTabKey = false);
    graphikos::painter::ShapeDetails selectNextCell(Direction key, bool shift = false, bool tabKey = false);
    void selectedCellTrigger();
    /**
     * below functions are used for  textEditing
     * 
     */
    void setTableId(std::string id);
    std::string getTableId();
    std::shared_ptr<TextEditorController> getTextEditor();
    bool isTextEditMode();
    bool initTextEditor(graphikos::painter::ShapeDetails cellDetails);
    virtual void setTextEditor();
    virtual void updateTextEditor(graphikos::painter::ShapeDetails cellDetails);

    void refreshControllerRect(graphikos::painter::GLRect rect, std::string imageKey, bool instantRefresh = false);

    bool exitTextEditor(bool triggerEvent = true);
    void populateCellSelection(graphikos::painter::ShapeDetails& cellShapeDetails);

    void dataUpdated(bool needRender = false, std::vector<std::string> shapeIds = {}) override; // call it after composing..
    void updateCellLayer(graphikos::painter::ShapeDetails& cellDetails);
    void onShapeDataChange(std::vector<std::string> shapeIds, bool isFontAdd);
    void updateSelectedData(bool forceUpdate = false);
    bool goToTextEdit(int rowIndex, int columnIndex, int formIndex = -1, int toIndex = -1, bool selectAll = false);

    virtual void throwAddOrDeleteRowColCallback(bool isAddOp, bool isColumn, bool towardsLeft) {};
    void renderTableRowColBox();
    void updateTableRowColBox(SelectedShape shape, bool considerFromCache = true, std::shared_ptr<TableRowColBox> tableBoxObj = nullptr);
    std::string generateColumnName(int index);
    void clearTableRowColBox(std::shared_ptr<TableRowColBox> tableBoxObj = nullptr);

    void reRenderCellSelection(com::zoho::shapes::ShapeObject* shapeObject, graphikos::painter::ShapeDetails updatedCellDetails);
    graphikos::painter::GLRect reRenderCellSelectionBox(graphikos::painter::GLPath path);
};

#endif