#include <composer/TextData.hpp>


namespace com {
namespace zoho {
namespace shapes{
    class Paragraph;
    class Portion;
    class TextBody;
    class PortionProps;
}
namespace collaboration {
class DocumentContentOperation;
class DocumentContentOperation_Component;
enum DocumentContentOperation_Component_OperationType : int;
class DocumentOperation_MutateDocument;
class DocumentOperation;
class Custom;
class DocumentContentOperation_Component_Text;
class DocumentContentOperation_Component_Value;
}
}
}

class TextConverter {
public:
    static CharData getParaPortions(int index, com::zoho::shapes::TextBody textBody);
    static TextData convertToParaPortions(int si, int ei, com::zoho::shapes::TextBody textBody);
    static TextData convertToParaPortions(com::zoho::collaboration::DocumentContentOperation_Component_Text text, com::zoho::shapes::TextBody textBody);
    static std::string utf16_to_utf8(std::u16string const& utf16);
    static std::u16string utf8_to_utf16(std::string const& utf8);
};
