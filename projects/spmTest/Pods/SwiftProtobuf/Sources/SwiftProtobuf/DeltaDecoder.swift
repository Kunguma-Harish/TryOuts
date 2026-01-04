//
//  DeltaDecoder.swift
//  Pods
//
//  Created by Nagarjun L V on 14/08/17.
//
//

import Foundation
//import SwiftProtobuf

public enum DeltaDecodingError: Error {
    /// Something was wrong
    case failure
}

public struct DeltaDecoder: Decoder {
    
    
    /// Returns the next field number, or nil when the end of the input is
    /// reached.
    ///
    /// For JSON and text format, the decoder translates the field name to a
    /// number at this point, based on information it obtained from the message
    /// when it was initialized.
    mutating public func nextFieldNumber() throws -> Int? {
        if fieldNumbers.isEmpty || currentIndex >= fieldNumbers.count {
            return nil
        }
        let index = currentIndex
        currentIndex += 1
        return fieldNumbers[index]
    }
    
    mutating public func decodeSingularFloatField(value: inout Float) throws{
        
    }
    
    mutating public func decodeSingularFloatField(value: inout Float?) throws{
        value = Float(NSString(string : self.valueString as! String).floatValue)
    }
    
    mutating public func decodeRepeatedFloatField(value: inout [Float]) throws{
        
    }
    
    mutating public func decodeSingularDoubleField(value: inout Double) throws{
        
    }
    
    mutating public func decodeSingularDoubleField(value: inout Double?) throws{
        
    }
    
    mutating public func decodeRepeatedDoubleField(value: inout [Double]) throws{
        
    }
    
    mutating public func decodeSingularInt32Field(value: inout Int32) throws{
        print("SingularInt32")
    }
    
    mutating public func decodeSingularInt32Field(value: inout Int32?) throws{
        value = Int32(self.valueString as! String)
        print("2.SingularInt32")
    }
    
    mutating public func decodeRepeatedInt32Field(value: inout [Int32]) throws{
        
    }
    
    mutating public func decodeSingularInt64Field(value: inout Int64) throws{
        print("SingularInt64")
    }
    
    mutating public func decodeSingularInt64Field(value: inout Int64?) throws{
         print("2.SingularInt64")
    }
    
    mutating public func decodeRepeatedInt64Field(value: inout [Int64]) throws{
        
    }
    
    mutating public func decodeSingularUInt32Field(value: inout UInt32) throws{
        
    }
    
    mutating public func decodeSingularUInt32Field(value: inout UInt32?) throws{
        
    }
    
    mutating public func decodeRepeatedUInt32Field(value: inout [UInt32]) throws{
        
    }
    
    mutating public func decodeSingularUInt64Field(value: inout UInt64) throws{
        
    }
    
    mutating public func decodeSingularUInt64Field(value: inout UInt64?) throws{
        
    }
    
    mutating public func decodeRepeatedUInt64Field(value: inout [UInt64]) throws{
        
    }
    
    mutating public func decodeSingularSInt32Field(value: inout Int32) throws{
        
    }
    
    mutating public func decodeSingularSInt32Field(value: inout Int32?) throws{
        
    }
    
    mutating public func decodeRepeatedSInt32Field(value: inout [Int32]) throws{
        
    }
    
    mutating public func decodeSingularSInt64Field(value: inout Int64) throws{
        
    }
    
    mutating public func decodeSingularSInt64Field(value: inout Int64?) throws{
        
    }
    
    mutating public func decodeRepeatedSInt64Field(value: inout [Int64]) throws{
        
    }
    
    mutating public func decodeSingularFixed32Field(value: inout UInt32) throws{
        
    }
    
    mutating public func decodeSingularFixed32Field(value: inout UInt32?) throws{
        
    }
    
    mutating public func decodeRepeatedFixed32Field(value: inout [UInt32]) throws{
        
    }
    
    mutating public func decodeSingularFixed64Field(value: inout UInt64) throws{
        
    }
    
    mutating public func decodeSingularFixed64Field(value: inout UInt64?) throws{
        
    }
    
    mutating public func decodeRepeatedFixed64Field(value: inout [UInt64]) throws{
        
    }
    
    mutating public func decodeSingularSFixed32Field(value: inout Int32) throws{
        
    }
    
    mutating public func decodeSingularSFixed32Field(value: inout Int32?) throws{
        
    }
    
    mutating public func decodeRepeatedSFixed32Field(value: inout [Int32]) throws{
        
    }
    
    mutating public func decodeSingularSFixed64Field(value: inout Int64) throws{
        
    }
    
    mutating public func decodeSingularSFixed64Field(value: inout Int64?) throws{
        
    }
    
    mutating public func decodeRepeatedSFixed64Field(value: inout [Int64]) throws{
        
    }
    
    mutating public func decodeSingularBoolField(value: inout Bool) throws{
        
    }
    
    mutating public func decodeSingularBoolField(value: inout Bool?) throws{
        value = Bool.init(self.valueString as! String)
    }
    
    mutating public func decodeRepeatedBoolField(value: inout [Bool]) throws{
        
    }
    
    mutating public func decodeSingularStringField(value: inout String) throws{
        
    }
    
    mutating public func decodeSingularStringField(value: inout String?) throws{
         value = self.valueString as! String
    }
    
    mutating public func decodeRepeatedStringField(value: inout [String]) throws{
        print("RString")
    }
    
    mutating public func decodeSingularBytesField(value: inout Data) throws{
        print("SingularBytes")
    }
    
    mutating public func decodeSingularBytesField(value: inout Data?) throws{
        print("SingularBytes")
    }
    
    mutating public func decodeRepeatedBytesField(value: inout [Data]) throws{
        print("RBytes")
    }
    
    // Decode Enum fields
    mutating public func decodeSingularEnumField<E: Enum>(value: inout E) throws where E.RawValue == Int{
        print("SingularEnum")
    }
    
    
    mutating public func decodeSingularEnumField<E: Enum>(value: inout E?) throws where E.RawValue == Int{
        value = E.init(name: self.valueString as! String)
    }
    
    
    mutating public func decodeRepeatedEnumField<E: Enum>(value: inout [E]) throws where E.RawValue == Int{
        
    }
    func decodeTextBody(){
        
    }
    // Decode Message fields
    mutating public func decodeSingularMessageField<M: Message>(value: inout M?) throws{
        if (currentIndex == fieldNumbers.count) {
            if opType == OperationType.text.rawValue{
                try value!.decodeMessage(decoder: &self)
                //value!.performSelector(#selector(decodeTextBody), with: nil, afterDelay: 0)
                return
            }
            if opType == OperationType.delete.rawValue{
                value = nil
                return
            }
            if (opType == OperationType.insert.rawValue && value == nil) || opType == OperationType.update.rawValue {
                
                value = try  M(jsonString: self.valueString as! String)
                
            }else {
                throw DeltaDecodingError.failure
            }
        }else{
            if value == nil {
                value = M()
            }
            try (value!).decodeMessage(decoder: &self)
        }
    }
    
    private func extendFieldNumbers(){
        
    }
    
    mutating public func decodeRepeatedMessageField<M: Message>(value: inout [M]) throws{
        let arrayIndex = try nextFieldNumber()
        if (currentIndex == fieldNumbers.count) {
            if opType == OperationType.insert.rawValue || opType == OperationType.update.rawValue {
                var message = try  M(jsonString: self.valueString as! String)
                value.append(message)
            }
            if opType == OperationType.delete.rawValue && arrayIndex != nil{
                value.remove(at: arrayIndex!)
            }
        }else{
            try (value[arrayIndex!]).decodeMessage(decoder: &self)
        }
    }
    
    // Decode Group fields
    mutating public func decodeSingularGroupField<G: Message>(value: inout G?) throws{
        
    }
    
    
    mutating public func decodeRepeatedGroupField<G: Message>(value: inout [G]) throws{
        
    }
    
    // Decode Map fields.
    // This is broken into separate methods depending on whether the value
    // type is primitive (_ProtobufMap), enum (_ProtobufEnumMap), or message
    // (_ProtobufMessageMap)
    mutating public func decodeMapField<KeyType, ValueType: MapValueType>(fieldType: _ProtobufMap<KeyType, ValueType>.Type, value: inout _ProtobufMap<KeyType, ValueType>.BaseType) throws{
        
    }
    
    
    mutating public func decodeMapField<KeyType, ValueType>(fieldType: _ProtobufEnumMap<KeyType, ValueType>.Type, value: inout _ProtobufEnumMap<KeyType, ValueType>.BaseType) throws where ValueType.RawValue == Int{
        
    }
    
    
    mutating public func decodeMapField<KeyType, ValueType>(fieldType: _ProtobufMessageMap<KeyType, ValueType>.Type, value: inout _ProtobufMessageMap<KeyType, ValueType>.BaseType) throws{
        
    }
    
    // Decode extension fields
    mutating public func decodeExtensionField(values: inout ExtensionFieldValueSet, messageType: Message.Type, fieldNumber: Int) throws{
        print("values:\(values)")
        print("Message:\(messageType) \(fieldNumber)")
    }
    
    // Run a decode loop decoding the MessageSet format for Extensions.
    mutating public func decodeExtensionFieldsAsMessageSet(values: inout ExtensionFieldValueSet,
                                                           messageType: Message.Type) throws{
        
        
    }
    
    /// Called by a `oneof` when it already has a value and is being asked to
    /// accept a new value. Some formats require `oneof` decoding to fail in this
    /// case.
    mutating public func handleConflictingOneOf() throws {
        
    }
    
    public enum OperationType : Int {
        case insert = 1// = 1
        case update = 2// = 2
        case delete = 4// = 4
        case text = 5// = 5
        case custom = 6// = 6
        case reorder = 7// = 7
    }
    
    internal var fieldNumbers : [Int] = []
    internal var valueString : Any
    internal var currentIndex = 0
    internal var opType : Int
    
    public init(fieldString : String , value : Any, operationType : Int) throws {
        self.valueString = value
        self.opType = operationType
        try self.setFieldNumbers(fieldString: fieldString)
    }
    
    public func getDetails() -> (Any,Int) {
        return (self.valueString,self.opType)
    }
    
    private mutating func setFieldNumbers (fieldString:String) throws {
        var fieldNumber = 0;
        for i in fieldString.split(separator: ",") {
            if let number = Int(i.description) {
                self.fieldNumbers.append(number)
            }
            else {
                let repeatedField = (i.description.split(separator: ":"))
                if repeatedField.count > 1, let number = Int(repeatedField[1].description) {
                    self.fieldNumbers.append(number)
                }
                else {
                    assert(false,"invalid fieldString")
                }
            }
        }
        
    }
}

