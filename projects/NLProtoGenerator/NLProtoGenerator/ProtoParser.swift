//
//  ProtoParser.swift
//  NLProtoGenerator
//
//  Created by kunguma-14252 on 14/05/25.
//

import Foundation

enum ProtoType {
    case message(name: String, fields: [(Int, ProtoField)], oneOfs: [ProtoOneOf], nested: [ProtoType])
    case enumeration(name: String, values: [String])
}

enum ProtoField {
    case scalar(name: String, type: String, isRepeated: Bool)
    case map(name: String, keyType: String, valueType: String)
}

struct ProtoOneOf {
    let name: String
    var fields: [(Int, ProtoField)]
}

struct ParsedProtoFile {
    let package: String?
    let imports: [String]
    let types: [ProtoType]
}

class ProtoParser {
    func parseImportsOfMultipleMessageFile(content: String) -> [String] {
        let lines = content.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }
        var imports: [String] = []
        for line in lines {
            guard !line.isEmpty, !line.hasPrefix("//") else { continue }
            if line.hasPrefix("message ") {
                var name = line.components(separatedBy: .whitespaces)[1]
                if name.contains(where: {$0 == "{"}) {
                    name.removeLast()
                }
                imports.append(name)
            }
        }
        return imports
    }
    
    func parse(protoContent: String) -> ParsedProtoFile {
        let lines = protoContent.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }

        var result: [ProtoType] = []
        var imports: [String] = []
        var packageName: String?

        var stack: [(messageName: String, fields: [(Int, ProtoField)], oneOfs: [ProtoOneOf], nested: [ProtoType])] = []
        var currentEnumName: String?
        var currentEnumValues: [String] = []

        var inOneOf: String?
        var currentOneOfFields: [(Int, ProtoField)] = []

        for line in lines {
            guard !line.isEmpty, !line.hasPrefix("//") else { continue }

            if line.hasPrefix("package ") {
                packageName = line
                    .replacingOccurrences(of: "package", with: "")
                    .replacingOccurrences(of: ";", with: "")
                    .trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("import ") {
                if let importFile = line.split(separator: "\"").dropFirst().first {
                    imports.append(String(importFile))
                }
            } else if line.hasPrefix("message ") {
                var name = line.components(separatedBy: .whitespaces)[1]
                if name.contains(where: {$0 == "{"}) {
                    name.removeLast()
                }
                stack.append((messageName: name, fields: [], oneOfs: [], nested: []))
            } else if line.hasPrefix("enum ") {
                var name = line.components(separatedBy: .whitespaces)[1]
                if name.contains(where: {$0 == "{"}) {
                    name.removeLast()
                }
                currentEnumName = name
                currentEnumValues = []
            } else if line.hasPrefix("oneof ") {
                inOneOf = line.components(separatedBy: .whitespaces)[1]
                currentOneOfFields = []
            } else if let (field, number) = parseMapField(line) ?? parseFieldLine(line) {
                if var last = stack.last {
                    if inOneOf != nil {
                        currentOneOfFields.append((number, field))
                    } else {
                        last.fields.append((number, field))
                    }
                    stack[stack.count - 1] = last
                }
            } else if currentEnumName != nil, line.contains("="), !line.contains("{") {
                let name = line.components(separatedBy: "=")[0].trimmingCharacters(in: .whitespaces)
                currentEnumValues.append(name)
            } else if line == "}" {
                if let oneofName = inOneOf {
                    var last = stack.removeLast()
                    last.oneOfs.append(ProtoOneOf(name: oneofName, fields: currentOneOfFields))
                    stack.append(last)
                    inOneOf = nil
                } else if let enumName = currentEnumName {
                    if var last = stack.last {
                        last.nested.append(.enumeration(name: enumName, values: currentEnumValues))
                        stack[stack.count - 1] = last
                    } else {
                        result.append(.enumeration(name: enumName, values: currentEnumValues))
                    }
                    currentEnumName = nil
                    currentEnumValues = []
                } else if let complete = stack.popLast() {
                    let message = ProtoType.message(
                        name: complete.messageName,
                        fields: complete.fields,
                        oneOfs: complete.oneOfs,
                        nested: complete.nested
                    )
                    if var parent = stack.last {
                        parent.nested.append(message)
                        stack[stack.count - 1] = parent
                    } else {
                        result.append(message)
                    }
                }
            }
        }

        return ParsedProtoFile(package: packageName, imports: imports, types: result)
    }

    private func parseFieldLine(_ line: String) -> (ProtoField, Int)? {
        let pattern = #"(?:(optional|required|repeated)\s+)?(\w+(?:\.\w+)*)\s+(\w+)\s*=\s*(\d+)(?:\s*\[.*?\])?\s*;"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
              match.numberOfRanges >= 5 else {
            return nil
        }

        let modifierRange = match.range(at: 1)
        let modifier: String? = modifierRange.location != NSNotFound ? String(line[Range(modifierRange, in: line)!]) : nil

        guard let typeRange = Range(match.range(at: 2), in: line),
              let nameRange = Range(match.range(at: 3), in: line),
              let numRange = Range(match.range(at: 4), in: line),
              let number = Int(line[numRange]) else {
            return nil
        }

        let type = String(line[typeRange])
        let name = String(line[nameRange])
        let isRepeated = modifier == "repeated"

        return (.scalar(name: name, type: type, isRepeated: isRepeated), number)
    }

    private func parseMapField(_ line: String) -> (ProtoField, Int)? {
        let pattern = #"map<(\w+),\s*(\w+)> (\w+) = (\d+)(?:\s*\[.*?\])?\s*;"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
              match.numberOfRanges == 5,
              let keyRange = Range(match.range(at: 1), in: line),
              let valueRange = Range(match.range(at: 2), in: line),
              let nameRange = Range(match.range(at: 3), in: line),
              let numRange = Range(match.range(at: 4), in: line),
              let number = Int(line[numRange]) else {
            return nil
        }

        let field = ProtoField.map(
            name: String(line[nameRange]),
            keyType: String(line[keyRange]),
            valueType: String(line[valueRange])
        )

        return (field, number)
    }
}
