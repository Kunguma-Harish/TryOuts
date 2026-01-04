#pragma once
#include <skia-extension/GLRect.hpp>
#include <painter/DrawingContext.hpp>
namespace com {
namespace zoho {
namespace chart {
class Chart;
class TitleElement;
class PieChart;
class Chart_ChartObj_Legend;
class SeriesDetails;
}
namespace shapes {
class GraphicFrame_GraphicFrameProps;
class GraphicFrame;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}

namespace graphikos {
namespace painter {
class ChartPainterImpl {
private:
    graphikos::painter::GLRect titleRect;
    graphikos::painter::GLRect legendRect;
    graphikos::painter::GLRect chartRect;
    void drawBg(const DrawingContext& dc, const graphikos::painter::GLRect& props);
    void drawTitle(const DrawingContext& dc, const com::zoho::chart::TitleElement& titleData, const graphikos::painter::GLRect& rect);
    void drawLegend(const DrawingContext& dc, graphikos::painter::GLRect& frameRect);
    void drawLegendRect(const DrawingContext& dc, const float& top, const float& left, const int& seriesIndex, const int& catIndex, const int& rectSize);
    void updateFrameRect(graphikos::painter::GLRect& mainRect, const graphikos::painter::GLRect& rect);
    graphikos::painter::GLRect getLegendTextRect(const DrawingContext& dc, const google::protobuf::RepeatedPtrField<std::string>& labels, const com::zoho::chart::Chart_ChartObj_Legend& chartObjectLeg, const graphikos::painter::GLRect& frameRect);
    virtual void drawPlot(const DrawingContext& dc, const graphikos::painter::GLRect& frameRect);
    virtual com::zoho::shapes::Properties getLegendRectProps(const int& index, const std::vector<com::zoho::chart::SeriesDetails*> seriesDetails);

protected:
    const com::zoho::chart::Chart* chart;
    static void drawStrokeFill(const DrawingContext& dc, const GLRect& rect, const com::zoho::shapes::Properties& props);
    ChartPainterImpl(const com::zoho::chart::Chart* _chart);

public:
    void draw(const DrawingContext& dc, const com::zoho::shapes::GraphicFrame_GraphicFrameProps& props, std::string chartId = "");
};

class ChartPainter {
private:
    const com::zoho::chart::Chart* chart;

public:
    ChartPainter(const com::zoho::chart::Chart* _chart);
    void draw(const DrawingContext& dc, const com::zoho::shapes::GraphicFrame_GraphicFrameProps& props, std::string chartId = "");
};
}
}