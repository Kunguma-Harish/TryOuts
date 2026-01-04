#ifndef _NL_RENDERTREEUTIL_H
#define _NL_RENDERTREEUTIL_H

#include <vector>
#include <string>
#include <nucleus/core/NLSkRTree.hpp>
#include <skia-extension/GLRect.hpp>
#include <memory>

struct TreeContainer {
    std::vector<std::string> shapeIds;
    std::vector<SkRect> bounds;
    std::shared_ptr<NLSkRTree> tree;
};

namespace TreeContainerUtil { // for the vector slicing operations done to shapeIds annd bounds vectors while update, insert, delete operations.

template <typename T>
static std::vector<T> insertAtIndex(std::vector<T> vec, T value, int index) {
    if (index == 0 && vec.size() == 0) {
        vec.push_back(value);
    } else {
        vec.insert(vec.begin() + index, value);
    }
    return vec;
}

template <typename T>
static int findIndex(std::vector<T>&vec, T value) {
    return (find(vec.begin(), vec.end(), value) - vec.begin());
}

template <typename T>
static bool isQueryPresentInArr(std::vector<T> vec, T value) {
    auto found = std::find(std::begin(vec), std::end(vec), value);

    return (found != std::end(vec) ? true : false);
}

template <typename T>
static void removeFromArr(std::vector<T>& vec, T value) {
    vec.erase(std::remove(vec.begin(), vec.end(), value), vec.end());
}

template <typename T>
static void appendArrs(std::vector<T>& first, std::vector<T>& second) {
    first.insert(first.end(), second.begin(), second.end());
}

void clearTreeContainer(std::shared_ptr<TreeContainer> treeContainer);
void createRTree(std::shared_ptr<TreeContainer> treeContainer);
void addToTreeContainer(std::shared_ptr<TreeContainer> treeContainer, std::string shapeId, SkRect rect, int index = -1);
void updateBounds(std::shared_ptr<TreeContainer> treeContainer, int index, SkRect rect);
void deleteFromTreeContainer(std::shared_ptr<TreeContainer> treeContainer, const std::string& shapeId);
}

class NLShapeIdUtil {
public:
    /**
   * @brief functions to perform  CRUD ops to ShapeId of shapes
   */
    static std::string removeCurrentShapeId(std::string shapeId);             //removes lastest shapeId appended to constructed componetId
    static std::string getCurrentShapeId(std::string shapeId);                //returns lastest shapeId appended to constructed componetId
    static bool isModified(std::string modifiedShapeId, std::string shapeId); //checks if shapeId is a part is the lastest shapeId appended to constructed componetId
    static std::string getActualShapeId(std::string shapeId);                 //removes str _end is present in shapeId and returns
    static std::string getBaseShapeId(std::string shapeId);
};

#endif
