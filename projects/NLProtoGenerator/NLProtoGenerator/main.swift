//
//  main.swift
//  NLProtoGenerator
//
//  Created by kunguma-14252 on 14/05/25.
//

import Foundation

let objcGen =  ObjcCodeGen()
var repeatedFieldGenerated: [String] = []
//main()

copyProtoFiles()

func copyProtoFiles() {
    var count = 0
    let destinationPath = "/Users/kunguma-14252/Documents/codeGen/showproto/generated/temp"
    let wd = "/Users/kunguma-14252/Documents/RemoteBoard/VaniProtoSupport/remoteboard-ios"
    let protoPath = wd + "/build/thirdparty/iOS/headers"
    
    let vaniProtofiles = getVaniProtoDocuments(wd)
    for file in vaniProtofiles {
        copyFiles(sourcePath: protoPath + "/vaniproto/cpp" + "/\(file)", dest: destinationPath + "/\(file)")
    }
    
    let commonProtofiles = getCommonProtoDocuments(wd)
    for file in commonProtofiles {
        copyFiles(sourcePath: protoPath + "/commonproto/cpp" + "/\(file)", dest: destinationPath + "/\(file)")
    }
    
    let shapesProtofiles = getShapesProtoDocuments(wd)
    for file in shapesProtofiles {
        copyFiles(sourcePath: protoPath + "/shapesproto/cpp" + "/\(file)", dest: destinationPath + "/\(file)")
    }

    let basekitProtofiles = getBaseKitProtoDocuments(wd)
    for file in basekitProtofiles {
        copyFiles(sourcePath: protoPath + "/basekitproto/cpp" + "/\(file)", dest: destinationPath + "/\(file)")
    }
    
    func copyFiles(sourcePath: String, dest: String) {
        do {
            if FileManager.default.fileExists(atPath: sourcePath) {
               let sourceURL = URL(fileURLWithPath: sourcePath)
               let destURL = URL(fileURLWithPath: dest)
                try FileManager.default.copyItem(at: sourceURL, to: destURL)
                count += 1
            }
            print("\(count) - File's copied successfully.")
        } catch {
            print("Error copying file: \(error)")
        }
    }
}


func main() {
    iterateFiles(shouldRegister: true)
    iterateFiles(shouldGenerate: true)
    
    do {
        let wd = "/Users/kunguma-14252/Documents/RemoteBoard/new/remoteboard-ios/"
        let path = wd + "/build/thirdparty/iOS/headers/commonproto/cpp/fields.proto"
        let url = URL(fileURLWithPath: path)
        let content = try String(contentsOf: url, encoding: .utf8)
        let imports = ProtoParser().parseImportsOfMultipleMessageFile(content: content)
        let header = ObjcCodeGen().generateForMultipleMessageProto(using: imports, name: "Fields")
        try header.write(to: URL(fileURLWithPath: wd + "/Vani/Native/iOS/Nucleus Bridge/Generated/NLFields.hpp"), atomically: true, encoding: .utf8)

    } catch {
        print(error)
    }
    print("Process Completed 👍🏻")
}

func iterateFiles(shouldRegister: Bool = false, shouldGenerate: Bool = false) {
    let wd = "/Users/kunguma-14252/Documents/RemoteBoard/VaniProtoSupport/remoteboard-ios"
    let protoPath = wd + "/build/thirdparty/iOS/headers"
    
    let vaniProtofiles = getVaniProtoDocuments(wd)
    for file in vaniProtofiles {
        guard let data = readDocument(of: protoPath + "/vaniproto/cpp" + "/\(file)") else {return}
        if shouldRegister {
            objcGen.registerEnumTypes(from: data.types)
        } else if shouldGenerate {
            generateObjcFiles(using: data, arr: &repeatedFieldGenerated)
        }
    }
    
    let commonProtofiles = getCommonProtoDocuments(wd)
    for file in commonProtofiles {
        guard let data = readDocument(of: protoPath + "/commonproto/cpp" + "/\(file)") else {return}
        if shouldRegister {
            objcGen.registerEnumTypes(from: data.types)
        } else if shouldGenerate {
            generateObjcFiles(using: data, arr: &repeatedFieldGenerated)
        }
    }
    
    let shapesProtofiles = getShapesProtoDocuments(wd)
    for file in shapesProtofiles {
        guard let data = readDocument(of: protoPath + "/shapesproto/cpp" + "/\(file)") else {return}
        if shouldRegister {
            objcGen.registerEnumTypes(from: data.types)
        } else if shouldGenerate {
            generateObjcFiles(using: data, arr: &repeatedFieldGenerated)
        }
    }

    let basekitProtofiles = getBaseKitProtoDocuments(wd)
    for file in basekitProtofiles {
        guard let data = readDocument(of: protoPath + "/basekitproto/cpp" + "/\(file)") else {return}
        if shouldRegister {
            objcGen.registerEnumTypes(from: data.types)
        } else if shouldGenerate {
            generateObjcFiles(using: data, arr: &repeatedFieldGenerated)
        }
    }
}

func getVaniProtoDocuments(_ wd: String) -> [String] {
    do {
        let path = wd + "/build/thirdparty/iOS/headers/vaniproto/cpp"
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        return contents.filter({$0.hasSuffix(".proto")})
    } catch {
        print("Vani Proto Doc Err")
        print(error)
    }
    return []
}

func getCommonProtoDocuments(_ wd: String) -> [String] {
    do {
        let path = wd + "/build/thirdparty/iOS/headers/commonproto/cpp"
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        return contents.filter({$0.hasSuffix(".proto")})
    } catch {
        print("Common Proto Doc Err")
        print(error)
    }
    return []
}

func getShapesProtoDocuments(_ wd: String) -> [String] {
    do {
        let path = wd + "/build/thirdparty/iOS/headers/shapesproto/cpp"
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        return contents.filter({$0.hasSuffix(".proto")})
    } catch {
        print(error)
    }
    return []
}

func getBaseKitProtoDocuments(_ wd: String) -> [String] {
    do {
        let path = wd + "/build/thirdparty/iOS/headers/basekitproto/cpp"
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        return contents.filter({$0.hasSuffix(".proto")})
    } catch {
        print(error)
    }
    return []
}

func readDocument(of path: String) -> ParsedProtoFile? {
    do {
        let url = URL(fileURLWithPath: path)
        let content = try String(contentsOf: url, encoding: .utf8)
        let parsedProtoFile = ProtoParser().parse(protoContent: content)
//        printParsedProtoFile(parsedProtoFile)
        return parsedProtoFile
    } catch {
        print("Failed to read the file. \(error)")
    }
    return nil
}

func generateObjcFiles(using parsedProtoFile: ParsedProtoFile, arr: inout [String]) {
    let data = objcGen.generateObjcFiles(from: parsedProtoFile)

    for file in data.files {
        do {
            let curDir = "/Users/kunguma-14252/Documents/projects/NLProtoGenerator/NLProtoGenerator"
            let wd = "/Users/kunguma-14252/Documents/RemoteBoard/new/remoteboard-ios/Vani/Native/iOS/Nucleus Bridge"
            
            try FileManager.default.createDirectory(atPath: wd + "/Generated", withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: wd + "/Generated/Repeated", withIntermediateDirectories: true)
            try FileManager.default.createDirectory(atPath: wd + "/Generated/Objc_Generated", withIntermediateDirectories: true)
            
            let path = wd + "/Generated/Objc_Generated/\(file.filename)"
            let url = URL(fileURLWithPath: path)
            try file.content.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed.")
        }
    }
    generateRepeatedFields(using: data.repeatedFields, arr: &arr)
    
}

func generateRepeatedFields(using data: [RepeatedFieldDataState], arr: inout [String]) {
    for rept in data {
        switch rept {
        case .enumeration(let repeatedFieldData):
            generateRptFieldForEnum(rept: repeatedFieldData, arr: &arr)
        case .message(let repeatedFieldData):
            generateRptFieldForMessage(rept: repeatedFieldData, arr: &arr)
        }
    }
}

func generateRptFieldForMessage(rept: RepeatedFieldData, arr: inout [String]) {
    let macroGen = MessageMacroGen(
        objcType: rept.objcType,
        cppType: rept.cppType,
        wrapperClassName: rept.wrapperClass
    ).generate()
    for i in macroGen {
        guard !arr.contains(where: {$0 == i.name}) else { continue }
        do {
            let curDir = "/Users/kunguma-14252/Documents/projects/NLProtoGenerator/NLProtoGenerator"
            let wd = "/Users/kunguma-14252/Documents/RemoteBoard/new/remoteboard-ios/Vani/Native/iOS/Nucleus Bridge"
            try FileManager.default.createDirectory(atPath: wd + "/Generated/Repeated/Message", withIntermediateDirectories: true)
            
            let path = wd + "/Generated/Repeated/Message/\(i.name)"
            let url = URL(fileURLWithPath: path)
            try i.content.write(to: url, atomically: true, encoding: .utf8)
            arr.append(i.name)
        } catch {
            print("Failed.")
        }
    }
}

func generateRptFieldForEnum(rept: RepeatedFieldData, arr: inout [String]) {
    let macroGen = EnumMacroGen(
        objcType: rept.objcType,
        cppType: rept.cppType,
        wrapperClassName: rept.wrapperClass
    ).generate()
    for i in macroGen {
        guard !arr.contains(where: {$0 == i.name}) else { continue }
        do {
            let curDir = "/Users/kunguma-14252/Documents/projects/NLProtoGenerator/NLProtoGenerator"
            let wd = "/Users/kunguma-14252/Documents/RemoteBoard/new/remoteboard-ios/Vani/Native/iOS/Nucleus Bridge"
            
            try FileManager.default.createDirectory(atPath: wd + "/Generated/Repeated/Enum", withIntermediateDirectories: true)
            
            let path = wd + "/Generated/Repeated/Enum/\(i.name)"
            let url = URL(fileURLWithPath: path)
            try i.content.write(to: url, atomically: true, encoding: .utf8)
            arr.append(i.name)
        }catch {
            print("Failed.")
        }
    }
}

func printParsedProtoFile(_ protoFile: ParsedProtoFile) {
    print("package - \(protoFile.package ?? "None")\n")
    for imp in protoFile.imports {
        print("import - \(imp)")
    }
    print()
    printProtoTypes(protoFile.types)
}

func printProtoTypes(_ types: [ProtoType], indent: String = "") {
    for type in types {
        switch type {
        case .message(let name, let fields, let oneOfs, let nested):
            print("\(indent)message \(name) {")
            for (num, field) in fields {
                switch field {
                case .scalar(let name, let type, let isRepeated):
                    let rep = isRepeated ? "repeated " : ""
                    print("\(indent)  \(rep)\(type) \(name) = \(num);")
                case .map(let name, let keyType, let valueType):
                    print("\(indent)  map<\(keyType), \(valueType)> \(name) = \(num);")
                }
            }
            for oneof in oneOfs {
                print("\(indent)  oneof \(oneof.name) {")
                for (num, field) in oneof.fields {
                    switch field {
                    case .scalar(let name, let type, _):
                        print("\(indent)    \(type) \(name) = \(num);")
                    case .map(let name, let keyType, let valueType):
                        print("\(indent)    map<\(keyType), \(valueType)> \(name) = \(num);")
                    }
                }
                print("\(indent)  }")
            }
            if !nested.isEmpty {
                printProtoTypes(nested, indent: indent + "  ")
            }
            print("\(indent)}")
        case .enumeration(let name, let values):
            print("\(indent)enum \(name) {")
            for (index, val) in values.enumerated() {
                print("\(indent)  \(val) = \(index);")
            }
            print("\(indent)}")
        }
    }
}
