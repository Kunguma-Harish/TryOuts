//
//  ObjcCodeGenerator.swift
//  NLProtoGenerator
//
//  Created by kunguma-14252 on 14/05/25.
//

import Foundation

enum RepeatedFieldDataState {
    case enumeration(RepeatedFieldData)
    case message(RepeatedFieldData)
}

struct RepeatedFieldData {
    let wrapperClass, objcType, cppType: String
}

extension ObjcCodeGen {
    func registerEnumTypes(from protoTypes: [ProtoType], parentName: String? = nil) {
        for type in protoTypes {
            switch type {
            case .message(let name, _, _, let nested):
                let className = fullClassName(parent: parentName, current: name)
                globalAllTypes.insert(className)
                registerEnumTypes(from: nested, parentName: className)
            case .enumeration(let name, _):
                if let parentName {
                    globalEnumTypes[name] = "NL\(parentName)_\(name)"
                } else {
                    globalEnumTypes[name] = "NL\(name)"
                }
            }
        }
    }
}

class ObjcCodeGen {
    var globalEnumTypes: [String: String] = [:]
    var globalAllTypes = Set<String>()
    private var allRepeatedFields: [RepeatedFieldDataState] = []
    
    func generateForMultipleMessageProto(using imports: [String], name: String) -> String {
        var result = ""
        result += "#ifndef NL\(name)_hpp\n"
        result += "#define NL\(name)_hpp\n\n"
        result += "#import <Foundation/Foundation.h>\n\n"
        for importClass in imports {
            if importClass == "BarChartField" {
                result += "#include \"NLChartField_\(importClass).hpp\" \n"
            } else {
                result += "#include \"NL\(importClass).hpp\" \n"
            }
        }
        result += "\n #endif /* NL\(name)_hpp */\n"
        return result
    }
    
    func generateObjcFiles(from proto: ParsedProtoFile) -> (files: [(filename: String, content: String)], repeatedFields: [RepeatedFieldDataState]) {
        var files: [(String, String)] = []

//        var allTypes = Set<String>()
//        var allEnumTypes = [String: String]()
        var importTypes = Set<String>()

        for imp in proto.imports {
            let components = imp.components(separatedBy: "/")
            if let last = components.last?.components(separatedBy: ".").first {
                importTypes.insert(last)
            }
        }

        func registerTypes(_ message: ProtoType, parentName: String?) {
            guard case let .message(name, _, _, nested) = message else { return }
            let className = fullClassName(parent: parentName, current: name)
//            allTypes.insert(className)

            for nestedType in nested {
                switch nestedType {
                case .enumeration(let enumName, _):
//                    if let parentName {
//                        allEnumTypes[enumName] = "NL\(parentName)_\(name)_\(enumName)"
//                    } else {
//                        allEnumTypes[enumName] = "NL\(name)_\(enumName)"
//                    }
                    break
                case .message(_, _, _, _):
                    registerTypes(nestedType, parentName: className)
                }
            }
        }

        func collectMessages(_ message: ProtoType, parentName: String?, package: String?, imports: [String], allTypes: Set<String>, allEnumTypes: [String: String]) {
            guard case let .message(name, _, _, nested) = message else { return }
            let className = fullClassName(parent: parentName, current: name)

            let header = generateHeaderForMessage(message, parentName: parentName, package: package, imports: imports, nested: nested, enumTypes: allEnumTypes, allTypes: allTypes, importTypes: importTypes)
            let impl = generateImplForMessage(message, parentName: parentName, package: package, imports: imports, allTypes: allTypes, allEnumTypes: allEnumTypes, importTypes: importTypes)
            
            files.append(("NL\(className).hpp", header))
            files.append(("NL\(className).mm", impl))

            for nestedType in nested {
                collectMessages(nestedType, parentName: className, package: package, imports: imports, allTypes: allTypes, allEnumTypes: allEnumTypes)
            }
        }
        
        func collectEnum(_ type: ProtoType) {
            guard case let .enumeration(name, _) = type else { return }
            let header = generateHeaderForEnum(type)
            files.append(("NL\(name).hpp", header))
        }

        for type in proto.types {
            registerTypes(type, parentName: nil)
        }

        for type in proto.types {
            var _imports = proto.imports
            _imports.removeAll(where: { $0 == "google/protobuf/protoextensions.proto"})
            if case .enumeration = type {
                collectEnum(type)
            } else {
                collectMessages(type, parentName: nil, package: proto.package, imports: _imports, allTypes: globalAllTypes, allEnumTypes: globalEnumTypes)
//                collectMessages(type, parentName: nil, package: proto.package, imports: _imports, allTypes: allTypes, allEnumTypes: allEnumTypes)
            }
        }
        
        return (files, allRepeatedFields)
    }

    private func implForField(_ field: ProtoField, parentName: String, allTypes: Set<String>, allEnumTypes: [String: String], importTypes: Set<String>) -> String {
        switch field {
        case let .scalar(name, type, isRepeated):
            let callerName = name.lowercased()
            let isCustom = type.contains(".") || CharacterSet.uppercaseLetters.contains(type.unicodeScalars.first!)
            let baseType = type.components(separatedBy: ".").last!
            let fullType = fullClassName(parent: parentName, current: baseType)

            if isRepeated {
                if isCustom {
                    if allTypes.contains(fullType) {
                        return """
                        - (NLRepeatedField_NL\(fullType) *)\(name) {
                            return [[NLRepeatedField_NL\(fullType) alloc] init:&inner->\(callerName)()];
                        }
                        """
                    } else if let enumTypeName = allEnumTypes[baseType] {
                        return """
                        - (NLRepeatedField_\(enumTypeName) *)\(name) {
                            return [[NLRepeatedField_\(enumTypeName) alloc] init:&inner->\(callerName)()];
                        }
                        """
                    }
                    
                    return """
                    - (NLRepeatedField_NL\(baseType) *)\(name) {
                        return [[NLRepeatedField_NL\(baseType) alloc] init:&inner->\(callerName)()];
                    }
                    """
                } else if type == "string" {
                    return """
                    - (NLRepeatedField_NSString *)\(name) {
                        return [[NLRepeatedField_NSString alloc] init:&inner->\(callerName)()];
                    }
                    """
                } else if type == "int32" {
                    return """
                    - (NLRepeatedField_int *)\(name) {
                        return [[NLRepeatedField_int alloc] init:&inner->\(callerName)()];
                    }
                    """
                } else if type == "float" {
                    return """
                    - (NLRepeatedField_float *)\(name) {
                        return [[NLRepeatedField_float alloc] init:&inner->\(callerName)()];
                    }
                    """
                }
                
                return """
                - (NSArray *)\(name) {
                    NSMutableArray *arr = [NSMutableArray array];
                    for (const auto& item : inner->\(callerName)()) {
                        \(isCustom ? "[arr addObject:[[NL\(fullType) alloc] init:&item]];" : "[arr addObject:@(item)];")
                    }
                    return arr;
                }
                """
            }  else if type == "int32" {
                return """
                - (int)\(name) {
                    return inner->\(callerName)();
                }
                """
            } else if type == "string" {
                return """
                - (NSString *)\(name) {
                    return [NSString stringWithUTF8String:inner->\(callerName)().c_str()];
                }
                """
            } else if type == "bool" {
                return """
                - (bool)\(name) {
                    return inner->\(callerName)();
                }
                """
            } else if type == "float" {
                return """
                - (float)\(name) {
                    return inner->\(callerName)();
                }
                """
            } else if isCustom {
                if type.hasPrefix("Show.") {
                    let enumName = objcTypeEnumImpl(from: type)
                    return """
                    - (\(enumName))\(name) {
                        int value = inner->\(callerName)();
                        return (\(enumName))value;
                    }
                    """
                } else if let enumName = allEnumTypes[baseType] {
                    return """
                    - (\(enumName))\(name) {
                        int value = inner->\(callerName)();
                        return (\(enumName))value;
                    }
                    """
                } else if allTypes.contains(fullType) {
                    return """
                    - (NL\(fullType) *)\(name) {
                        return [[NL\(fullType) alloc] init:&inner->\(callerName)()];
                    }
                    """
                } else if allTypes.contains(baseType) || importTypes.contains(baseType.lowercased()) {
                    return """
                    - (NL\(baseType) *)\(name) {
                        return [[NL\(baseType) alloc] init:&inner->\(callerName)()];
                    }
                    """
                } else if let getType = allTypes.first(where: { $0.hasSuffix("_\(baseType)") }) {
                    return """
                    - (NL\(getType) *)\(name) {
                        return [[NL\(getType) alloc] init:&inner->\(callerName)()];
                    }
                    """
                }
            }

            return """
            - (NSNumber *)\(name) {
                return [[NSNumber alloc] initWithInt:inner->\(name)()];
            }
            """

        case let .map(name, _, _):
            return """
            - (NSDictionary *)\(name) {
                return @{}; // map conversion to be implemented
            }
            """
        }
    }

    private func headerForField(_ field: ProtoField, parentName: String?, enumTypes: [String: String], allTypes: Set<String>, importTypes: Set<String>) -> String {
        switch field {
        case let .scalar(name, type, isRepeated):
            let baseType = type.components(separatedBy: ".").last!
            let fullType = fullClassName(parent: parentName, current: baseType)
            let isCustom = type.contains(".") || CharacterSet.uppercaseLetters.contains(type.unicodeScalars.first!)
            
            var objCType: String
            if type == "string" {
                objCType = "NSString *"
            } else if type == "bool" {
                objCType = "bool"
            } else if type == "float" {
                objCType = "float"
            } else if type == "int32" {
                objCType = "int"
            } else if isCustom {
                if type.hasPrefix("Show.") {
                    objCType = objcTypeEnumHeaderName(from: type)
                } else if let enumName = enumTypes[baseType] {
                    objCType = "\(enumName)"
                } else if allTypes.contains(fullType) {
                    objCType = "NL\(fullType) *"
                } else if allTypes.contains(baseType) || importTypes.contains(baseType.lowercased()) {
                    objCType = "NL\(baseType) *"
                } else if let getType = allTypes.first(where: { $0.hasSuffix("_\(baseType)") }) {
                    objCType = "NL\(getType) *"
                } else {
                    objCType = "NL\(baseType)"
                }
            } else {
                objCType = "NSNumber *"
            }

            if isRepeated {
                if objCType.contains(where: {$0 == "*"}) {
                    return "- (NLRepeatedField_\(objCType))\(name);"
                } else {
                    return "- (NLRepeatedField_\(objCType) *)\(name);"
                }
            }
            
            return "- (\(objCType))\(name);"

        case let .map(name, _, _):
            return "- (NSDictionary *)\(name);"
        }
    }

    private func objcTypeEnumHeaderName(from type: String) -> String {
        let parts = type.split(separator: ".")

        guard parts.count >= 2 else {
            return type
        }

        let className = parts[1]
        let nestedParts = parts.dropFirst(2).joined(separator: "_")
        
        if nestedParts.isEmpty {
            return "NL\(className)"
        }
        return "NL\(className)_\(nestedParts)"
    }

    private func objcTypeEnumImpl(from type: String) -> String {
        let parts = type.split(separator: ".")

        guard parts.count >= 2 else {
            return type
        }

        let className = parts[1]
        let nestedParts = parts.dropFirst(2).joined(separator: "_")
        
        if nestedParts.isEmpty {
            return "NL\(className)"
        }
        return "NL\(className)_\(nestedParts)"
    }

    private func fullClassName(parent: String?, current: String) -> String {
        if let parent = parent {
            return "\(parent)_\(current)"
        } else {
            return current
        }
    }
    
    private func generateHeaderForEnum(_ enumeration: ProtoType) -> String {
        var result = ""
        guard case let .enumeration(name, _) = enumeration else {
            return result
        }
        result += "#ifndef NL\(name)_hpp\n"
        result += "#define NL\(name)_hpp\n\n"
        result += "#import <Foundation/Foundation.h> \n\n"
        result += generateEnum(enumeration, parentName: "")
        result += "\n #endif /* NL\(name)_hpp */\n"
        return result
    }

    private func generateHeaderForMessage(_ message: ProtoType, parentName: String?, package: String?, imports: [String], nested: [ProtoType], enumTypes: [String: String], allTypes: Set<String>, importTypes: Set<String>) -> String {
        guard case let .message(name, fields, _, nestedTypes) = message else { return "" }
        var includedImports: [String] = []
        let className = fullClassName(parent: parentName, current: name)
        var result = ""
        result += "#ifndef NL\(className.replacingOccurrences(of: "_", with: "__"))_hpp\n"
        result += "#define NL\(className.replacingOccurrences(of: "_", with: "__"))_hpp\n\n"
        result += "#import <Foundation/Foundation.h>\n"

        for imp in imports {
            let base = (imp as NSString).lastPathComponent.replacingOccurrences(of: ".proto", with: "")
            let capitalized = base.prefix(1).uppercased() + base.dropFirst()
            let header = "#include \"NL\(capitalized).hpp"
            if !includedImports.contains(header) {
                result += "\(header)\"\n"
                includedImports.append(header)
            }
        }

        for nestedType in nested {
            if case let .message(nestedName, _, _, _) = nestedType {
                let nestedClassName = fullClassName(parent: className, current: nestedName)
                let header = "#include \"NL\(nestedClassName).hpp"
                if !includedImports.contains(header) {
                    result += "\(header)\"\n"
                    includedImports.append(header)
                }
            }
        }

        var forwardDeclareEnum: [String] = []
        for (_, field) in fields {
            if case let .scalar(_, type, isRepeated) = field {
                let baseType = type.components(separatedBy: ".").last!
                let isCustom = type.contains(".") || CharacterSet.uppercaseLetters.contains(type.unicodeScalars.first!)
                let candidate = fullClassName(parent: parentName, current: baseType)
                let fullClassName = fullClassName(parent: className, current: baseType)
                if !isRepeated {
                    if allTypes.contains(candidate) {
                        let header = "#include \"NL\(candidate).hpp"
                        if !includedImports.contains(header) {
                            result += "\(header)\"\n"
                            includedImports.append(header)
                        }
                    } else if let enumName = globalEnumTypes[baseType] {
                        let parentName = getParentName(from: enumName)
                        let header = "#include \"\(parentName).hpp"
                        if !includedImports.contains(header),
                           "NL\(className)" != parentName {
                            result += "\(header)\"\n"
                            forwardDeclareEnum.append(enumName)
                            includedImports.append(header)
                        }
                    } else if let typeClassName = allTypes.first(where: {$0.hasSuffix("_\(baseType)")}) {
                        let header = "#include \"NL\(typeClassName).hpp"
                        if !includedImports.contains(header) {
                            result += "\n"
                            result += "\(header)\"\n"
                            includedImports.append(header)
                        }
                    }
                }

                if isRepeated {
                    if isCustom {
                        if allTypes.contains(candidate) {
                            let wrapperClassName = "NLRepeatedField_NL\(candidate)"
                            if !includedImports.contains(where: {$0 == wrapperClassName}) {
                                result += "#include \"\(wrapperClassName).hpp\"\n"
                                let data = RepeatedFieldData(wrapperClass: wrapperClassName, objcType: "NL\(candidate)", cppType: "\(package!.split(separator: ".").joined(separator: "::"))::\(candidate)")
                                allRepeatedFields.append(.message(data))
                                includedImports.append(wrapperClassName)
                            }
                        } else if let enumType = enumTypes[baseType] {
                            let wrapperClassName = "NLRepeatedField_\(enumType)"
                            if !includedImports.contains(where: {$0 == wrapperClassName}) {
                                result += "#include \"\(wrapperClassName).hpp\"\n"
                                let data = RepeatedFieldData(wrapperClass: wrapperClassName, objcType: enumType, cppType: "\(package!.split(separator: ".").joined(separator: "::"))::\(fullClassName)")
                                allRepeatedFields.append(.enumeration(data))
                                includedImports.append(wrapperClassName)
                            }
                        } else if allTypes.contains(fullClassName) {
                            let wrapperClassName = "NLRepeatedField_NL\(fullClassName)"
                            if !includedImports.contains(where: {$0 == wrapperClassName}) {
                                result += "#include \"\(wrapperClassName).hpp\"\n"
                                let data = RepeatedFieldData(wrapperClass: wrapperClassName, objcType: "NL\(fullClassName)", cppType: "\(package!.split(separator: ".").joined(separator: "::"))::\(fullClassName)")
                                allRepeatedFields.append(.message(data))
                                includedImports.append(wrapperClassName)
                            }
                        } else {
                            let wrapperClassName = "NLRepeatedField_NL\(baseType)"
                            if !includedImports.contains(where: {$0 == wrapperClassName}) {
                                result += "#include \"\(wrapperClassName).hpp\"\n"
                                let data = RepeatedFieldData(wrapperClass: wrapperClassName, objcType: "NL\(baseType)", cppType: "\(package!.split(separator: ".").joined(separator: "::"))::\(baseType)")
                                allRepeatedFields.append(.message(data))
                                includedImports.append(wrapperClassName)
                            }
                        }
                    } else if type == "string" {
                        result += "#include \"NLRepeatedField_NSString.hpp\"\n"
                    } else if type == "int32" {
                        result += "#include \"NLRepeatedField_int.hpp\"\n"
                    } else if type == "float" {
                        result += "#include \"NLRepeatedField_float.hpp\"\n"
                    }
                }
            }
        }

        if let package = package {
            let ns = package.split(separator: ".").joined(separator: "::")
            result += "\n#ifdef __cplusplus\n"
            result += namespaceDeclaration(for: parentName, current: name, package: ns)
            result += "#endif\n"
        }

        for enumName in forwardDeclareEnum {
            result += "\n"
            result += "typedef NS_ENUM(NSInteger, \(enumName));"
            result += "\n"
        }
        
        for enumDef in nestedTypes {
            result += generateEnum(enumDef, parentName: className)
        }

        result += "\n@interface NL\(className) : NSObject\n"
        if let package = package {
            let ns = package.split(separator: ".").joined(separator: "::")
            result += "#ifdef __cplusplus\n- (instancetype)init:(const \(ns)::\(className)*)pointer;\n#endif\n"
        }

        for (_, field) in fields {
            print("parentName : \(parentName ?? "nil") -- className : \(className)")
            result += "\(headerForField(field, parentName: parentName, enumTypes: enumTypes, allTypes: allTypes, importTypes: importTypes))\n"
//            result += "\(headerForField(field, parentName: className, enumTypes: enumTypes, allTypes: allTypes, importTypes: importTypes))\n"
        }

        result += "@end\n\n"
        result += "#endif /* NL\(className.replacingOccurrences(of: "_", with: "__"))_hpp */\n"
        return result
    }

    private func generateImplForMessage(_ message: ProtoType, parentName: String?, package: String?, imports: [String], allTypes: Set<String>, allEnumTypes: [String: String], importTypes: Set<String>) -> String {
        guard case let .message(name, fields, _, _) = message else { return "" }

        let className = fullClassName(parent: parentName, current: name)
        var result = ""
        result += "#include \"NL\(className).hpp\"\n"

        for imp in imports {
            let base = (imp as NSString).lastPathComponent.replacingOccurrences(of: ".proto", with: "")
            result += "#include \"\(base).pb.h\"\n"
        }
        
        if package != nil,
           let parentClass = className.components(separatedBy: "_").first
        {
            result += "#include \"\(parentClass.lowercased()).pb.h\"\n"
        }

        result += "\n@implementation NL\(className) {\n"
        if let package = package {
            let ns = package.split(separator: ".").joined(separator: "::")
            result += "    const \(ns)::\(className) *inner;\n"
        } else {
            result += "    const \(className) *inner;\n"
        }
        result += "}\n\n"

        for (_, field) in fields {
            result += "\(implForField(field, parentName: className, allTypes: allTypes, allEnumTypes: allEnumTypes, importTypes: importTypes))\n"
        }

        if let package = package {
            let ns = package.split(separator: ".").joined(separator: "::")
            result += "- (instancetype)init:(const \(ns)::\(className) *)pointer {\n"
        } else {
            result += "- (instancetype)init:(const \(className) *)pointer {\n"
        }

        result += "    self = [super init];\n    if (self) {\n        self->inner = pointer;\n    }\n    return self;\n}\n\n@end\n"
        return result
    }

    private func namespaceDeclaration(for parentName: String?, current: String, package: String) -> String {
        let nsClass = parentName != nil ? "\(parentName!)_\(current)" : current
        return "namespace \(package) {\n    class \(nsClass);\n}\n"
    }

    private func generateEnum(_ enumDef: ProtoType, parentName: String) -> String {
        var result = ""
        guard case .enumeration(let name, let values) = enumDef else {
            return result
        }

        let className = parentName.isEmpty ? "NL\(name)" : "NL\(parentName)_\(name)"
        result += "typedef NS_ENUM(NSInteger, \(className)) {\n"
        for (index, caseName) in values.enumerated() {
            result += "    \(className)_\(caseName) = \(index),\n"
        }
        result += "};\n\n"
        return result
    }

    func getParentName(from fullTypeName: String) -> String {
        let components = fullTypeName.components(separatedBy: "_")
        guard components.count > 1 else { return fullTypeName }
        return components.dropLast().joined(separator: "_")
    }
}
