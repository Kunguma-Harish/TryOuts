#pragma once

#include <skia-extension/GLPoint.hpp>
#include <skia-extension/GLRect.hpp>
#include <vector>

namespace Show {
enum ChartField_ChartType : int;
enum ChartField_DataLabelPosition : int;
}

namespace com {
namespace zoho {
namespace chart {
class Chart;
class TitleElement;
class PieChart;
class ChartStyle_StyleData;
class Chart_ChartObj;
class ChartStyle;
class ChartAxis;
class ChartAxis_AxisDetails;
class ChartLayout_AxisLayoutData;
class SeriesDetails;
}
namespace shapes {
class GraphicFrame_GraphicFrameProps;
class GraphicFrame;
class NumberReference;
class PortionProps;
class Properties;
class Fill;
class Stroke;
class NumberReference;
class StringReference;
class TextBody;
class Color;
}
namespace common {
enum HorizontalAlignType : int;
}
}
}

namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
template <typename T>
class RepeatedField;
}
}

namespace graphikos {
namespace painter {
namespace internal {
struct AxisData;
struct UnitAxisData;
}

struct UnitData {
    const int start;
    const int noOfUnits;
    const float factor;

    UnitData(int start, int noOfUnits, float factor)
        : start(start), noOfUnits(noOfUnits), factor(factor) {}
};

class ChartUtil {
public:
    enum TextType {
        AXIS_LABELS,
        LEGEND_TITLE,
        CHART_TITLE,
        DATA_LABEL
    };
    static void getRenderableChartObject(com::zoho::chart::Chart& graphicFrame);
    static void updateChartStyleFromLayout(com::zoho::chart::Chart& chart);
    static bool checkIfFadeFillStyle(const ::google::protobuf::RepeatedPtrField<::com::zoho::chart::ChartStyle_StyleData>& styleData);
    static bool checkIfVaryColor(const com::zoho::chart::Chart_ChartObj& chartObjOrBuilder, const Show::ChartField_ChartType& chartType);
    static com::zoho::shapes::Properties getDataPointPropsFromDefaultStyle(const com::zoho::chart::ChartStyle& chartStyle, const bool& fadeFillStyle, const bool& dontVaryColor, const int& index, const int& seriesCount);
    static com::zoho::shapes::Fill getFadeAppliedFillColor(const com::zoho::shapes::Fill& fill, const int& highestIndex, const int& seriesIndex);
    static void addTweakOnColor(float& percent, com::zoho::shapes::Color* color);
    static com::zoho::shapes::Stroke getFadeAppliedStrokeColor(const com::zoho::shapes::Stroke& stroke, const int& highestIndex, const int& seriesIndex);
    static void updateAxisFromLayout(com::zoho::chart::ChartAxis& axis, const com::zoho::chart::ChartLayout_AxisLayoutData& axisLayoutData);
    static google::protobuf::RepeatedField<float> getNumbersFromNumberReference(const com::zoho::shapes::NumberReference& numberReference);
    static google::protobuf::RepeatedPtrField<std::string> getStringsFromStringReference(const com::zoho::shapes::StringReference& stringReference);
    static std::vector<com::zoho::chart::SeriesDetails*> getSeriesDetails(com::zoho::chart::Chart& chart);
    static void createTextBody(const std::string& label, const com::zoho::shapes::TextBody& textBody, const com::zoho::chart::ChartStyle& chartStyle, com::zoho::shapes::TextBody& editableTB, const TextType& textType);
    static com::zoho::shapes::PortionProps getDefaultLegendTextPrProps(const com::zoho::chart::ChartStyle& chartStyle);
    static com::zoho::shapes::PortionProps getDefaultTitlePrProps(const com::zoho::chart::ChartStyle& chartStyle);
    static com::zoho::shapes::PortionProps getDefaultPrPropsForAxisLabels(const com::zoho::chart::ChartStyle& chartStyle);
    static com::zoho::shapes::PortionProps getDefaultDataLabelPrProps(const com::zoho::chart::ChartStyle& chartStyle);
    static void getAxisRenderData(const com::zoho::chart::ChartAxis& chartAxis, const std::vector<com::zoho::chart::SeriesDetails*>& seriesDetailsList, const bool& labelInCross, const std::vector<float>& maxAndMinValues, const bool& isUntilMaxValue, const std::string& suffix, const float& axisLength, internal::AxisData& axisData);
    static UnitData getUnitAxisData(const float& axisLength, const float& maxValue, const float& minValue, const float& defaultMajorValue, const bool& isUntilMaxValue);
    static int getNoOfDivisionsForAxis(const float& unit, const float& maxValue, const bool& isUntilMaxValue);
    static google::protobuf::RepeatedPtrField<std::string> getLabelStrings(const float& max, const float& min, const float& factor, const std::string& suffix);
    static graphikos::painter::GLRect getValueFrameForYValueAxisData(const internal::UnitAxisData& yAxisRenderData, const internal::AxisData& xAxisRenderData, const graphikos::painter::GLRect& frame, const float& xValue, const float& yValue, const bool& xLabelInCross);
    static std::vector<com::zoho::shapes::TextBody> getAxisLabelTextBody(const internal::AxisData& axisData, const com::zoho::chart::ChartStyle& chartStyle);
    static com::zoho::shapes::TextBody createTextBody(const std::string& text, const com::zoho::shapes::PortionProps& portionProps);
    static std::vector<com::zoho::shapes::TextBody> getAxisTitleTextBody(const internal::AxisData& axisData, const com::zoho::chart::ChartStyle& chartStyle, const std::string& defaultAxisTitle);
    static com::zoho::shapes::PortionProps getDefaultPrPropsForAxisTitle(const com::zoho::chart::ChartStyle& chartStyle);
    static std::tuple<com::zoho::shapes::Properties, com::zoho::shapes::TextBody, Show::ChartField_DataLabelPosition> getDataLabelData(const int& seriesIndex, const int& categoryIndex, const com::zoho::chart::Chart* chart);
};
}
}