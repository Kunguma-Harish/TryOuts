#ifndef __NL_PBUTIL_H
#define __NL_PBUTIL_H

#include <string>
#include <fstream>

#include <google/protobuf/util/json_util.h>
#include <google/protobuf/message.h>
#include <google/protobuf/descriptor.h>
#include <absl/status/status.h>
#include <absl/strings/string_view.h>

namespace com {
namespace zoho {
namespace shapes {
class PathObject;
}
}
}
class SkData;

namespace graphikos {
namespace common {
class PBUtil {
public:
    static bool ParseToMessage(google::protobuf::Message* message, const uint8_t* data, const size_t len, bool parsePartially);
    static SkData* ParseToBytes(google::protobuf::Message* message);
    static bool parseFromBytes(google::protobuf::Message* message, std::vector<uint8_t> dataVec){
        return ParseToMessage(message, dataVec.data(), dataVec.size(),true);
    }
   #if defined(NL_ENABLE_NEXUS)
        static std::vector<uint8_t> parseToBytesArray(google::protobuf::Message* message);
    #endif
    /**
   * @brief Converts the given proto message to json std::string
   *
   * @param message
   * @return std::string
   */
    static inline std::string pb2json(const google::protobuf::Message& message) {
        std::string jsonStr;
        absl::Status status = google::protobuf::util::MessageToJsonString(message, &jsonStr);
        return jsonStr;
        // return ::pb2json(message);
    }

    /**
   * @brief Converts the given json std::string into message
   *
   * @param message reference to the message
   * @param json
   * @param json_size
   */
    static inline absl::Status json2pb(google::protobuf::Message& message, const char* json, size_t json_size) {
        absl::Status sts = google::protobuf::util::JsonStringToMessage(absl::string_view(json, json_size), &message);
        return sts;
        // ::json2pb(message, json, json_size);
    }

    static std::string pb2json_array(google::protobuf::RepeatedPtrField<google::protobuf::Message>* messages);

    /**
   * @brief Returns a reversed array
   *
   * @param arr array to reverse
   * @return google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* ownership is given to the caller
   */
    static google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* ReverseRepeatedPtrField(google::protobuf::RepeatedPtrField<com::zoho::shapes::PathObject>* arr);

    static void gc_log_info(const std::string& info);
    static void gc_log_error(const std::string& err);

    template <class T>
    static std::shared_ptr<T> GetMessage(const uint8_t* data, const size_t len) {
        if (data == nullptr || len <= 0) {
            gc_log_error("data is null, or size is invalid");

            return nullptr;
        }
        T* t = new T();
        if (t->ParsePartialFromArray(data, len)) {
            gc_log_info("Parse completed successfully");
            return std::shared_ptr<T>(t);
        }
        gc_log_error("Parse failed");
        return nullptr;
    }

    static size_t calculateProtobufObjectSize(const google::protobuf::Message& message) {
        size_t totalSize = 0;

        const google::protobuf::Descriptor* descriptor = message.GetDescriptor();
        const google::protobuf::Reflection* reflection = message.GetReflection();

        // Iterate through all fields in the message
        for (int i = 0; i < descriptor->field_count(); i++) {
            const google::protobuf::FieldDescriptor* field = descriptor->field(i);

            if (field->is_repeated()) {
                // Handle repeated fields
                int count = reflection->FieldSize(message, field);
                switch (field->cpp_type()) {
                case google::protobuf::FieldDescriptor::CPPTYPE_STRING: {
                    for (int j = 0; j < count; j++) {
                        const std::string& value = reflection->GetRepeatedString(message, field, j);
                        totalSize += value.capacity() + sizeof(std::string); // String overhead
                    }
                    totalSize += sizeof(std::vector<std::string>); // Vector overhead
                    break;
                }
                case google::protobuf::FieldDescriptor::CPPTYPE_MESSAGE: {
                    for (int j = 0; j < count; j++) {
                        const google::protobuf::Message& subMessage =
                            reflection->GetRepeatedMessage(message, field, j);
                        totalSize += calculateProtobufObjectSize(subMessage);
                    }
                    totalSize += sizeof(std::vector<void*>); // Vector overhead
                    break;
                }
                default: {
                    // For primitive types
                    totalSize += count * sizeof(void*) + sizeof(std::vector<void*>);
                    break;
                }
                }
            } else {
                // Handle non-repeated fields
                switch (field->cpp_type()) {
                case google::protobuf::FieldDescriptor::CPPTYPE_STRING: {
                    if (reflection->HasField(message, field)) {
                        const std::string& value = reflection->GetString(message, field);
                        totalSize += value.capacity() + sizeof(std::string);
                    }
                    break;
                }
                case google::protobuf::FieldDescriptor::CPPTYPE_MESSAGE: {
                    if (reflection->HasField(message, field)) {
                        const google::protobuf::Message& subMessage =
                            reflection->GetMessage(message, field);
                        totalSize += calculateProtobufObjectSize(subMessage);
                    }
                    break;
                }
                case google::protobuf::FieldDescriptor::CPPTYPE_INT32:
                case google::protobuf::FieldDescriptor::CPPTYPE_BOOL:
                    totalSize += sizeof(int32_t);
                    break;
                case google::protobuf::FieldDescriptor::CPPTYPE_INT64:
                    totalSize += sizeof(int64_t);
                    break;
                case google::protobuf::FieldDescriptor::CPPTYPE_FLOAT:
                    totalSize += sizeof(float);
                    break;
                case google::protobuf::FieldDescriptor::CPPTYPE_DOUBLE:
                    totalSize += sizeof(double);
                    break;
                case google::protobuf::FieldDescriptor::CPPTYPE_ENUM:
                    totalSize += sizeof(int);
                    break;
                default:
                    break;
                }
            }
        }

        // Add base message overhead
        totalSize += sizeof(message);

        return totalSize;
    }

    template <class T>
    static std::shared_ptr<T> GetMessageFromBytes(std::string& data) {
        if (data.empty()) {
            return nullptr;
        }
        std::shared_ptr<T> t = std::make_shared<T>();
        if (data[0] == '{') {
            // json
            if (json2pb(*t.get(), data.data(), data.size()).ok()) {
                return t;
            }
        }
        if (t->ParseFromString(data)) {
            gc_log_info("Parse completed successfully");
            return t;
        }
        gc_log_error("Parse failed");
        return nullptr;
    }

    template <class T>
    static std::shared_ptr<T> GetMessageFromFile(std::string path) {
        std::fstream input;
        input.open(path, std::ios::in | std::ios::binary);
        if (input.fail()) {
            gc_log_error("Cannot open file: " + path);
            return nullptr;
        }
        std::shared_ptr<T> t = std::make_shared<T>();
        if (t->ParsePartialFromIstream(&input)) {
            gc_log_info("Parse completed successfully");
            return t;
        }
        gc_log_error("Parse failed");
        return nullptr;
    }
};
}
}

#endif
