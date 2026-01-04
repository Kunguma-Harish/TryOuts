#ifndef __NL_TEXTCOMPOSER_H
#define __NL_TEXTCOMPOSER_H
#include <string>
#include <composer/Composer.hpp>
#include <composer/TextConverter.hpp>


struct OldValueObj {
    google::protobuf::Message* oldValues = nullptr;
    std::map<std::string, std::string> deleteData;
};

class TextComposer {
public:
    static std::string zeroWidthCharacter;
    static Composer composer;
    static void composeText(ProtoBuilder* builder, const com::zoho::collaboration::DocumentContentOperation_Component* component);

    static void updateAnimationIdsInParas(com::zoho::shapes::Paragraph* paragraph, com::zoho::collaboration::DocumentContentOperation_Component_Text text);
    static void updateParagraphIdInParas(com::zoho::shapes::Paragraph* paragraph, com::zoho::collaboration::DocumentContentOperation_Component_Text text);

    static com::zoho::collaboration::DocumentContentOperation_Component* updateParaId(int paraNum, com::zoho::collaboration::DocumentContentOperation_Component_Value* value);
    static com::zoho::collaboration::DocumentContentOperation_Component* updatePortionString(int paraNum, int portionNum, std::string value);
    static com::zoho::collaboration::DocumentContentOperation_Component* deleteTextField(int paraNum, int portionNum);
    static com::zoho::collaboration::DocumentContentOperation_Component* deletePortionType(int paraNum, int portionNum);

    static com::zoho::collaboration::DocumentContentOperation_Component* updatePortionValue(int paraNum, int portionNum, com::zoho::collaboration::DocumentContentOperation_Component_Text text);

    static com::zoho::collaboration::DocumentContentOperation_Component* addPara(int paraNum, com::zoho::shapes::Paragraph* para);
    static com::zoho::collaboration::DocumentContentOperation_Component* addPortion(int paraNum, int portionNum, com::zoho::shapes::Portion* portion, std::string t, com::zoho::collaboration::DocumentContentOperation_Component_Text* text);
    static com::zoho::collaboration::DocumentContentOperation_Component* addPortion(int paraNum, int portionNum, std::string portionText);
    static bool addPortions(int paraNum, int from, int to, int index, google::protobuf::RepeatedPtrField<com::zoho::shapes::Portion>* portions, google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* datas);
    static void addPortionsInRange(com::zoho::shapes::Paragraph* fromPara, com::zoho::shapes::Paragraph* toPara, int from, int to);

    static com::zoho::collaboration::DocumentContentOperation_Component* deletePortion(int paraNum, int portionNum);
    static void deletePortions(int paraNum, int from, int to, google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component>* datas);
    static com::zoho::collaboration::DocumentContentOperation_Component* deletePara(int paraNum);

    static std::string getValue(com::zoho::collaboration::DocumentContentOperation_Component_Text text);
    static void copyPortionPropsFromPrevious(com::zoho::shapes::Portion* prevPortion, com::zoho::shapes::PortionProps* newProps, bool toDelCommentIds, bool toDelBaseline);

    static bool isEmptyObject(CharData);
    static bool isEmptyPara(com::zoho::shapes::Paragraph* para);

    static OldValueObj updateOldValue(google::protobuf::Message* props1, google::protobuf::Message* props2, bool considerIsRepeated = true);
    static std::string stringMapToString(std::map<std::string, std::string> mapValues);
    static std::map<std::string, std::string> stringToStringMAP(std::string);
    static std::vector<std::string> splitString(const std::string& str, const char& ch);

    static std::string getAssociatedDataStrForTextField(com::zoho::shapes::Portion* portion);
    static bool composeTextInTextBody(google::protobuf::RepeatedPtrField<com::zoho::collaboration::DocumentContentOperation_Component_Text>, com::zoho::shapes::TextBody* textBody);
};

#endif
