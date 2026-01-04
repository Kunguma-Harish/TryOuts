#pragma once
#include <painter/chart/ChartPainter.hpp>
#include <painter/chart/ChartUtil.hpp>
namespace com {
namespace zoho {
namespace chart {
class Chart;
class PlotArea;
}
namespace shapes {
class orientation;
}
}
}
namespace graphikos {
namespace painter {
class AxesChartPainter : public ChartPainterImpl {
private:
    void setYAxisRenderData(const internal::AxisData& yAxisRenderData);
    void setXAxisRenderData(const internal::AxisData& xAxisRenderData);
    void getAxisRenderData(const com::zoho::chart::ChartAxis& chartAxis, const std::vector<com::zoho::chart::SeriesDetails*>& seriesDetailsList, const bool& orientationX, const bool& isLabelInCross, const GLRect& frame, internal::AxisData& axisData);
    void reduceFrameForAxes(const DrawingContext& dc, GLRect& frame);
    int getXAxisIndex();
    int getYAxisIndex();
    std::vector<float> getMaxAndMinValues(const std::vector<com::zoho::chart::SeriesDetails*>& seriesDetailsList, const bool& orientationX);
    void calculateAxesData(const DrawingContext& dc, GLRect& frame);
    void drawGrids(const DrawingContext& dc, const GLRect& frame);
    void drawBG(const DrawingContext& dc, const GLRect& frame);
    void drawAxes(const DrawingContext& dc, const GLRect& frame);
    void drawAxis(const DrawingContext& dc, const float& axisLength, const internal::AxisData& axisRenderData, const bool& isOrientationX, const float& tickLength, const GLRect& frame, const com::zoho::shapes::Stroke& stroke);
    virtual void drawPlotArea(const DrawingContext& dc, const GLRect& frame);
    void reduceFrameForLabels(const DrawingContext& dc, const GLPoint& maxSizeOfXAxisLabel, const GLPoint& maxSizeOfYAxisLabel, GLRect& frame);
    void reduceFrameForAxesTitle(const GLPoint& maxSizeOfXAxisTitle, const GLPoint& maxSizeOfYAxisTitle, GLRect& frame);
    void drawAxesLabels(const DrawingContext& dc, const GLPoint& originPoint, const std::vector<com::zoho::shapes::TextBody>& axisLabelTextBodies, const bool& isOrientationX, const GLPoint& maxSizeofAxisLabel, const GLRect& frame);
    void drawAxesTitle(const DrawingContext& dc, const GLPoint& originPoint, const std::vector<com::zoho::shapes::TextBody>& axisTitleBody, const bool& isOrientationX, const GLRect& frame);

protected:
    internal::AxisData* yAxisRenderData;
    internal::AxisData* xAxisRenderData;
    com::zoho::shapes::Properties getLegendRectProps(const int& index, const std::vector<com::zoho::chart::SeriesDetails*> seriesDetails) override;
    GLPoint getOriginPoint(const GLRect& frame);
    AxesChartPainter(const com::zoho::chart::Chart* _chart);
    void drawPlot(const DrawingContext& dc, const GLRect& frame) override;
    void drawChartSeriesLines(const DrawingContext& dc, const std::vector<GLRect>& seriesLinesDataList, const GLRect& frame, const int& categoryCount, const bool& isOrientationX);
    GLPoint getMaximumSizeOfTextBodies(const DrawingContext& dc, const std::vector<com::zoho::shapes::TextBody>& textBodies, const float& maximumTextWidth);
    ~AxesChartPainter();
};
}
}