#pragma once
#include <iostream>

#include <textbody.pb.h>
#include <parastyle.pb.h>
#include <fill.pb.h>
namespace google {
namespace protobuf {
template <typename T>
class RepeatedPtrField;
}
}
class RemoteBoardDefaultValues {
private:
public:
    com::zoho::shapes::TextBody shapeListStylesDefaultValues;
    com::zoho::shapes::TextBody textListStylesDefaultValues;
    com::zoho::shapes::ParaStyle tableParastyleDefaultValues;
    com::zoho::shapes::TextBoxProps textBodyDefaultValues;
    com::zoho::shapes::PortionProps linkPropsDefaultValues;
    com::zoho::shapes::Fill fillDefaultValues;
    RemoteBoardDefaultValues();
};
