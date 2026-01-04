#pragma once
#include <painter/chart/AxesChartPainter.hpp>
namespace com {
namespace zoho {
namespace chart {
class Chart;
class BarChart;
}
namespace shapes {
}
}
}

namespace graphikos {
namespace painter {
class ColumnChartPainter : public AxesChartPainter {
private:
    const com::zoho::chart::BarChart* barChart;
    void drawDataLabelsInPlotArea(const DrawingContext& dc, const float& barLeft, const float& barTop, const float& barHeight, const float& barWidth, const int& seriesIndex, const int& categoryIndex, const GLRect& frame);

protected:
    void drawPlotArea(const DrawingContext& dc, const GLRect& frame) override;

public:
    ColumnChartPainter(const com::zoho::chart::Chart* _chart);
};
}
}