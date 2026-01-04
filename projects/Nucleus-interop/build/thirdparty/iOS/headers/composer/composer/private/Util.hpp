#ifndef __NL_UTIL_H
#define __NL_UTIL_H

#include <google/protobuf/util/json_util.h>
#include <logger/Logger.hpp>
#include <absl/status/status.h>
#include <absl/strings/string_view.h>

namespace graphikos {
namespace composer {
class Util {
public:
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
    }

    static inline bool ParseToMessage(google::protobuf::Message* message, const uint8_t* data, const size_t len, bool parsePartially) {
        //We use a reinterpret_cast to turn our plain int into a uint8_t pointer. After
        //which we can play with the data just like we would normally.
        logger::loginfo << "parseToMessage called" << logger::end;
        if (data == nullptr || message == nullptr || len <= 0) {
            return false;
        }
        logger::loginfo << "Parsing from array" << logger::end;
        if (parsePartially) {
            message->ParsePartialFromArray(reinterpret_cast<const void*>(data), len);
        } else {
            message->ParseFromArray(reinterpret_cast<const void*>(data), len);
        }
        return true;
    }
};
}
}

#endif
