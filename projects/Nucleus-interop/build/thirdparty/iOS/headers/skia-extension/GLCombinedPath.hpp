#pragma once
#include <include/pathops/SkPathOps.h>
#include <skia-extension/GLPath.hpp>
#include <variant>
#include <vector>

namespace graphikos::painter {

struct PathNode;

class GLCombinedPath {
public:
    GLCombinedPath();
    GLCombinedPath(const GLCombinedPath& path);
    GLCombinedPath(GLCombinedPath&& path);
    GLCombinedPath(GLPath path);

    void addPath(const GLPath& path, SkPathOp op);
    void addPath(const GLCombinedPath& path, SkPathOp op);
    void addPath(GLCombinedPath&& path, SkPathOp op);
    bool contains(SkPoint point) const;
    GLPath getResultantPath() const;
    int getPathNodesSize() const;
    bool isEmpty() const;

    ~GLCombinedPath();

private:
    std::vector<PathNode*> pathNodes;
};
struct PathNode {
    std::variant<GLPath, GLCombinedPath> path;
    SkPathOp op = SkPathOp::kUnion_SkPathOp;
};
}
