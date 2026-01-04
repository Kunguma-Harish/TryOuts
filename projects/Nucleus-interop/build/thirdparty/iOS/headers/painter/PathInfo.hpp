#ifndef PATH_INFO_HPP
#define PATH_INFO_HPP

#include <vector>
#include <skia-extension/GLPath.hpp>
#include <painter/PainterConstants.hpp>

class PathInfo {
private:
    PathInfo(const PathInfo& other) = delete;
    PathInfo& operator=(const PathInfo& other) = delete;
    void _transform(const SkMatrix& matrix, std::vector<graphikos::painter::GLPath>& paths) {
        for (size_t i = 0; i < paths.size(); i++) {
            paths[i].transform(matrix);
        }
    }

public:
    std::vector<graphikos::painter::GLPath> strokePaths;
    std::vector<graphikos::painter::GLPath> fillPaths;

    PathInfo(const std::vector<graphikos::painter::GLPath>& strokePaths, const std::vector<graphikos::painter::GLPath>& fillPaths)
        : strokePaths(strokePaths), fillPaths(fillPaths) {}
    PathInfo() {}
    PathInfo(PathInfo&& pathInfo) noexcept
        : strokePaths(std::move(pathInfo.strokePaths)), fillPaths(std::move(pathInfo.fillPaths)) {
    }
    PathInfo& operator=(PathInfo&& pathInfo) noexcept {
        if (this != &pathInfo) {
            strokePaths = std::move(pathInfo.strokePaths);
            fillPaths = std::move(pathInfo.fillPaths);
        }
        return *this;
    }

    PathInfo clone() const {
        return PathInfo(strokePaths, fillPaths);
    }
    bool isEmpty() const {
        bool strokePathEmpty = true;
        bool fillPathEmpty = true;
        if (this->strokePaths.size()) {
            for (const graphikos::painter::GLPath& path : this->strokePaths) {
                if (!path.isEmpty()) {
                    strokePathEmpty = false;
                    break;
                }
            }
        }
        if (strokePathEmpty && this->fillPaths.size()) {
            for (const graphikos::painter::GLPath& path : this->fillPaths) {
                if (!path.isEmpty()) {
                    fillPathEmpty = false;
                    break;
                }
            }
        }
        return strokePathEmpty && fillPathEmpty;
    }
    void transform(const SkMatrix& matrix) {
        _transform(matrix, this->strokePaths);
        _transform(matrix, this->fillPaths);
    }
    void setFillRule(std::vector<graphikos::painter::GLPath>& paths) {
        for (size_t i = 0; i < paths.size(); i++) {
            paths[i].setFillType(Constants::fillType);
        }
    }
};

#endif
