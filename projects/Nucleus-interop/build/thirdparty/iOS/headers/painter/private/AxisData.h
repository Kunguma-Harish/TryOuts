#ifndef AXIS_DATA_H
#define AXIS_DATA_H
#include <chart.pb.h>

namespace graphikos {
namespace painter {
namespace internal {
struct AxisData {
    float max;
    float major = 1;
    float min = 1;
    float minor = 1;
    float crossAt = 0;
    google::protobuf::RepeatedPtrField<std::string> labels;
    Show::ChartField_LabelPos labelPos = Show::ChartField_LabelPos::ChartField_LabelPos_NEXTTO;
    float labelOffset = 100;
    com::zoho::common::HorizontalAlignType labelAlign = com::zoho::common::HorizontalAlignType::CENTER;
    int skipTick = 1;
    int skipLabel = 1;
    bool isReverse = false;
    com::zoho::chart::ChartAxis_AxisDetails axisDetails;
    bool lableInCross = true;
    com::zoho::chart::ChartAxis_AxisDetails_Cross_CrossType crossType;
    std::vector<com::zoho::shapes::TextBody> labelTextBodies;
    graphikos::painter::GLPoint maxTextWidth;
    std::vector<com::zoho::shapes::TextBody> axisTitleBody;
    graphikos::painter::GLPoint maximumTitleWidth;
};

struct UnitAxisData : public AxisData {
    UnitAxisData(float max, float min, float major, const std::string& suffix) {
        google::protobuf::RepeatedPtrField<std::string> labels = ChartUtil::getLabelStrings(max, min, major, suffix);
        this->labels = labels;
        this->max = max;
        this->min = min;
        this->major = major;
        this->minor = major / 2.0f;
    }
    UnitAxisData(const AxisData& axisData) {
        this->labels = axisData.labels;
        this->max = axisData.max;
        this->min = axisData.min;
        this->major = axisData.major;
        this->minor = axisData.major / 2.0f;
    }
};
}
}
}
#endif