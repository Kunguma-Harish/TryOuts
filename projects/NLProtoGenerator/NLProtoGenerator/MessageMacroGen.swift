//
//  MacroGen.swift
//  NLProtoGenerator
//
//  Created by kunguma-14252 on 15/05/25.
//

import Foundation

class MessageMacroGen {
    let objcType: String
    let cppType: String
    let wrapperClassName: String

    init(objcType: String, cppType: String, wrapperClassName: String) {
        self.objcType = objcType
        self.cppType = cppType
        self.wrapperClassName = wrapperClassName
    }

    func generateHpp() -> (name: String, content: String) {
        var lines: [String] = []

        lines.append("#ifndef \(wrapperClassName)_hpp")
        lines.append("#define \(wrapperClassName)_hpp")
        lines.append("")
        lines.append("#include \"NLRepeatedPtrField.hpp\"")
        lines.append("#include \"\(objcType).hpp\"")
        lines.append("")

        if cppType.hasPrefix("com::") {
            let cppClassName = cppType.components(separatedBy: "::").last ?? cppType
            lines.append("#ifdef __cplusplus")
            lines.append("namespace \(cppType.dropLast(cppClassName.count + 2)) {")
            lines.append("    class \(cppClassName);")
            lines.append("}")
            lines.append("")
            lines.append("namespace google::protobuf {")
            lines.append("template <typename T>")
            lines.append("class RepeatedPtrField;")
            lines.append("}")
            lines.append("#endif")
            lines.append("")
        }

        lines.append("DEFINE_REPEATED_PTR_FIELD_WRAPPER(\(wrapperClassName), \(cppType), \(objcType))")
        lines.append("")
        lines.append("#endif")

        let content = lines.joined(separator: "\n")
        return (name: "\(wrapperClassName).hpp", content: content)
    }

    func generateMm() -> (name: String, content: String) {
        var lines: [String] = []

        lines.append("#include \"\(wrapperClassName).hpp\"")
        lines.append("#include \"repeated_ptr_field.h\"")

        let importLine = generatePbIncludeLine(from: objcType)
        lines.append("#include \"\(importLine)\"")
        lines.append("")
        lines.append("IMPLEMENT_REPEATED_PTR_FIELD_WRAPPER(\(wrapperClassName), \(cppType), \(objcType))")

        let content = lines.joined(separator: "\n")
        return (name: "\(wrapperClassName).mm", content: content)
    }

    private func generatePbIncludeLine(from objcType: String) -> String {
        // Convert something like NLDocument_ScreenOrShapeElement to document.pb.h
        // or NLDocumentData to documentdata.pb.h
        let pattern = "^NL([A-Z][a-zA-Z0-9]*)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: objcType, range: NSRange(objcType.startIndex..., in: objcType)),
           let range = Range(match.range(at: 1), in: objcType) {
            let prefix = String(objcType[range])
            return "\(prefix.lowercased()).pb.h"
        }
        return "unknown.pb.h" // fallback
    }

    func generate() -> [(name: String, content: String)] {
        return [generateHpp(), generateMm()]
    }
}
