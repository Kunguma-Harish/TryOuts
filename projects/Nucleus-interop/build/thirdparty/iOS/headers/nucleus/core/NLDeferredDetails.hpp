#pragma once
// #include <include/patch/PictureUtil.h>
#include <skia-extension/DeferredDetails.hpp>
#include <iostream>
#include <variant>

/// TODO: inherit from SkDeferredDetails

class NLDeferredDetails : public DeferredDetails {

public:
    struct TreeElements {
        int currentIndex;
        std::vector<int> treeIndices;
    };

    using Element = std::variant<int, TreeElements>;

    std::vector<Element> elementStack;
    void* timeOutCheckDisabler = nullptr;
    size_t currentDepth = 0;

    NLDeferredDetails(int soavg, int maxcount) : DeferredDetails(soavg, maxcount) { elementStack.reserve(20); };

    NLDeferredDetails::Element getStartIndex() {
        return elementStack.size() > currentDepth && !timeOutCheckDisabler ? elementStack[currentDepth] : Element(-1);
    }

    void pushIndex(int currentIndex, std::optional<std::vector<int>> treeIndices = {}) {
        // std::cout << " push:  ";
        // for (auto& i : path) {
        //     std::cout << i.index << " ";
        // }
        // std::cout << ": currentDepth: " << currentDepth << std::endl;
        if (!timeOutCheckDisabler) {
            if (elementStack.size() == currentDepth) {
                if (treeIndices) {
                    Element temp = TreeElements{currentIndex, treeIndices.value()};
                    elementStack.push_back(temp);
                } else {
                    elementStack.push_back(currentIndex);
                }
            } else {
                // continuing playback
                // std::cout << "continuing plaback" << std::endl;
                Element elem = elementStack.at(currentDepth);
                int index = std::holds_alternative<int>(elem) ? std::get<int>(elem) : std::get<TreeElements>(elem).currentIndex;
                SkASSERT_RELEASE(elementStack.size() > currentDepth && (index == currentIndex));
            }
            currentDepth++;
        }
    }

    void popIndex() {
        // std::cout << " pop ";
        // for (auto& i : elementStack) {
        //     std::cout << i.index << " ";
        // }
        // std::cout << std::endl;
        if (!timeOutCheckDisabler) {
            elementStack.pop_back();
            SkASSERT(currentDepth > 0);
            currentDepth--;
        }
    }

    bool checkTimeOut() {
        return timeOutCheckDisabler ? false : !SkDeferredDetails::checkTimeLimit();
    }

    bool isStartOrEnd() {
        return elementStack.empty() && DeferredDetails::isStartOrEnd();
    }

    void disableTimeOutCheck(void* disabler) {
        if (!timeOutCheckDisabler)
            timeOutCheckDisabler = disabler;
    }

    void enableTimeOutCheck(void* disabler) {
        if (disabler == timeOutCheckDisabler)
            timeOutCheckDisabler = nullptr;
    }
};
