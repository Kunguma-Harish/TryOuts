#pragma once
#include <painter/chart/ChartPainter.hpp>
namespace com {
namespace zoho {
namespace chart {
class Chart;
class PieChart;
class SeriesDetails;
}
namespace shapes {

}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedField;
}
}

namespace graphikos {
namespace painter {
class PieChartPainter : public ChartPainterImpl {
private:
    const com::zoho::chart::PieChart* pieChart;
    com::zoho::shapes::Properties getLegendRectProps(const int& index, const std::vector<com::zoho::chart::SeriesDetails*> seriesDetails) override;
    void drawPieChart(const DrawingContext& dc, const GLRect& rect, const google::protobuf::RepeatedField<float>& data, const std::vector<com::zoho::shapes::Properties>& props, const com::zoho::chart::SeriesDetails& seriesDetails);
    void drawLabel(const DrawingContext& dc, const google::protobuf::RepeatedField<float>& data, const float& radius, const float& midAngle, const float& sweepAngle, const int& index, const float& total, const SkPoint& offset, const SkPoint& center);

protected:
    void drawPlot(const DrawingContext& dc, const GLRect& rect) override;

public:
    PieChartPainter(const com::zoho::chart::Chart* _chart);
};
}
}