#pragma once

#include <painter/GraphicFramePainter.hpp>

namespace com {
namespace zoho {
namespace shapes {
class GraphicFrame_GraphicFrameProps;
class TableStyle_TablePartStyle;
class Reference;
class Table;
class TableCellBorders;
class TableCellBorders_CellBorder;
class TableStyle;
class Table_TableRow_TableCell;
class Transform;
class TextBody;
class FontReference;
}
}
}

class SkPaint;

#define CELL_WIDTH 40
#define CELL_HEIGHT 39

namespace graphikos {
namespace painter {

struct TableLine {
    bool leftLine = false;
    bool topLine = false;
    bool rightLine = false;
    bool bottomLine = false;
    ShapeDetails cellDetails;
    com::zoho::shapes::Table_TableRow_TableCell* actualCell = nullptr; // needed for checking if merged cell in row column resize
};
struct CellPathDetails {
    size_t rowIndex;
    size_t colIndex;
    GLPath path;
    bool rectPresetGeomPresent = false;
    bool applyGeom = false;
    float topLeft = 0, bottomLeft = 0, topRight = 0, bottomRight = 0;
    bool topLeftCell, bottomLeftCell = false, topRightCell = false, bottomRightCell = false;
};

class TablePainter {
private:
    com::zoho::shapes::Stroke* defaultStroke = nullptr;
    com::zoho::shapes::Table* table = nullptr;
    std::string tableId = "";
    std::vector<float> rowHeight;
    std::vector<size_t> mergeCellRowIndex;
    std::vector<size_t> mergeCellColIndex;
    com::zoho::shapes::TableStyle* tablestyle = nullptr;
    bool merged = false;

public:
    TablePainter(com::zoho::shapes::Table* _table, std::string tableId);
    com::zoho::shapes::Table* getTable();
    ~TablePainter();

    com::zoho::shapes::Transform getUpdatedTableTransform(com::zoho::shapes::Transform* transform, Matrices matrices, IProvider* provider);
    void setDefaultStroke();
    std::vector<float> getRowHeight();
    std::vector<float> getColumnWidths(IProvider* provider, SkMatrix scaleMatrix);

    void draw(com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, const DrawingContext& dc, std::string tableId = "", bool canMergeBorders = true);
    void drawTableCell(const DrawingContext& dc, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, std::string tableId);
    CellPathDetails getCellPath(com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, GLRect rect, size_t rowIndex, size_t colIndex, size_t lastRowIndex = -1, size_t lastColIndex = -1);
    void drawTable(SkCanvas* canvas, GLPath path, SkPaint parentPaint);
    void drawBorder(com::zoho::shapes::TableCellBorders* border, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, CellPathDetails& pathDetails, const DrawingContext& dc);
    void drawTableStyle(IProvider* provider);
    float getParaHeight(int index);
    SkPaint getBorderPaint(com::zoho::shapes::TableCellBorders_CellBorder* cellBorder, com::zoho::shapes::Transform* transform, SkMatrix matrix, SkPaint paint, IProvider* provider);

    GLPath getPropsRangeOfCell(IProvider* provider, com::zoho::shapes::Table_TableRow_TableCell* cell, com::zoho::shapes::Transform* transform);
    GLPath getWholeTablePath(bool withRadius, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, Matrices matrices, const graphikos::painter::RenderSettings* renderSettings, IProvider* provider);
    GLPath getFillPath(bool withRadius, com::zoho::shapes::Transform* transform, Matrices matrices, IProvider* provider, com::zoho::shapes::Fill* fill, bool forTable, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props);
    GLPath getPropsRange(IProvider* provider, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, Matrices matrices);
    GLPath getTableBorderPath(IProvider* provider, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, Matrices matrices);
    com::zoho::shapes::TextBody* getTextBody(std::string cellId);
    std::tuple<int, int> getTableCellIndex(std::string cellId);

    ShapeDetails getCellDetailsById(IProvider* provider, com::zoho::shapes::Transform* transform, Matrices matrices, std::string id);
    ShapeDetails getCellDetails(IProvider* provider, com::zoho::shapes::Transform* transform, Matrices matrices, int i, int j, bool fromCache = true);

    float calculateTableWidth(IProvider* provider, SkMatrix scaleMatrix = SkMatrix());
    float calculateTableHeight(IProvider* provider, const graphikos::painter::RenderSettings* renderSettings, SkMatrix scaleMatrix = SkMatrix());

    void setTableStyle(int i, int j, com::zoho::shapes::Table_TableRow_TableCell* cell, com::zoho::shapes::TableStyle* tablestyle, IProvider* provider, bool canMergeBorders);
    void setCellStyle(int rowIndex, int colIndex, com::zoho::shapes::Table_TableRow_TableCell* cell, com::zoho::shapes::TableStyle_TablePartStyle* style, std::shared_ptr<com::zoho::shapes::FontReference> fontRef, IProvider* provider, bool canMergeBorders);
    void setCellFill(com::zoho::shapes::Table_TableRow_TableCell* cell, com::zoho::shapes::TableStyle_TablePartStyle* style, IProvider* provider, bool canMergeBorders);
    void setCellTextDefault(com::zoho::shapes::TextBody* textbody, IProvider* provider, std::shared_ptr<com::zoho::shapes::FontReference> fontRef = nullptr);

    bool isEven(int n, bool firstRowOrFirstColumn);

    std::shared_ptr<com::zoho::shapes::Stroke> getStrokeFromRef(com::zoho::shapes::Reference* ref, IProvider* provider);
    bool isMergeCell(int rowIndex, int colIndex);
    std::pair<float, float> calculateRowHeight(int i, IProvider* provider, SkMatrix matrix = SkMatrix(), const graphikos::painter::RenderSettings* renderSettings = nullptr); // pair - as paraheight is not always same as row height - para height will be the default height of the cell
    float getColumnWidth(int j);
    int getTotalColumns();
    int getTotalRows();

    bool lastMergeColumn(int i, int j, com::zoho::shapes::Table_TableRow_TableCell* cell);
    bool lastMergeRow(int i, int j, com::zoho::shapes::Table_TableRow_TableCell* cell);

    std::tuple<std::string, float> getHeightFromLastMergedRow(int i, int j, com::zoho::shapes::Table_TableRow_TableCell* cell, bool colMergePresent, IProvider* provider, float scale = 1.0f);
    std::tuple<std::string, float> getHeightFromLastMergedCol(int i, int j, com::zoho::shapes::Table_TableRow_TableCell* cell, IProvider* provider, float scale = 1.0f);

    int getStartingRowOfMerge(int i, int j);
    int getStartingColOfMerge(int i, int j);

    void renderTableCellWithoutText(ShapeDetails shapeDetails, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, const DrawingContext& dc);
    void renderTableCell(int i, int j, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, const DrawingContext& dc, com::zoho::shapes::Transform* transform, bool withText = false);
    float getHeightFromText(com::zoho::shapes::TextBody* textBody, com::zoho::shapes::Transform* transform, Matrices matrices, IProvider* provider, std::string cellId);
    TableLine traverseTable(GLRegion region, com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, Matrices matrices, GLPoint point, bool onModifier, com::zoho::shapes::Transform* gTrans, IProvider* provider, float selectionOffset = 0);
    GLRect getUpdatedTableTransform(ShapeDetails shapeDetails);
    ShapeDetails traverseTableByIndex(com::zoho::shapes::Transform* transform, Matrices matrices, int rowIndex, int cellIndex, com::zoho::shapes::Transform* gTrans, IProvider* provider);
    TableLine traverseCellBorder(com::zoho::shapes::Table_TableRow_TableCell* cell, com::zoho::shapes::Transform* transform, GLPoint point, SkMatrix matrix, IProvider* provider, float selectionOffset = 0);
    bool setTransformIfMergedCell(int i, int j, com::zoho::shapes::Transform* transform, com::zoho::shapes::Table_TableRow_TableCell* cell, int* lastRowIndex = nullptr, int* lastColIndex = nullptr, SkMatrix matrix = SkMatrix(), bool fromCache = true, IProvider* provider = nullptr);
    void setMergedStroke(com::zoho::shapes::Table_TableRow_TableCell* cell, int i, int j);
    std::tuple<int, int> traverseTableForIndex(com::zoho::shapes::GraphicFrame_GraphicFrameProps* props, Matrices matrices, GLPoint point, com::zoho::shapes::Transform* gTrans, IProvider* provider);
    void updateTableCellFill(com::zoho::shapes::Table_TableRow_TableCell& updatedCell, com::zoho::shapes::ShapeObject* shapeObject, IProvider* provider);
    bool isBorderApplied(std::string cellId, int side, IProvider* provider);

    com::zoho::shapes::Table_TableRow_TableCell* getCell(int i, int j);

    std::tuple<std::vector<GLRect>, std::vector<size_t>> getRowRects(com::zoho::shapes::Transform* transform, Matrices matrices, IProvider* provider, const graphikos::painter::RenderSettings* renderSettings);
    std::tuple<std::vector<GLRect>, std::vector<size_t>> getColumRects(com::zoho::shapes::Transform* transform, Matrices matrices, IProvider* provider, const graphikos::painter::RenderSettings* renderSettings);

    void setTableStyleForAllCells(IProvider* provider, bool canMergeBorders);

    float getDefaultRowHeight();
    float getDefaultColumnWidth(IProvider* provider);
    com::zoho::shapes::Transform getCellTransform(IProvider* provider, com::zoho::shapes::Transform* tableTransform, int rowIndex, int cellIndex, bool fromcache);
    
};
}
}
