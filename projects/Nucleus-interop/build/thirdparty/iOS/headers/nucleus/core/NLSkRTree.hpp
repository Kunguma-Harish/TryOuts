#ifndef __NL_NLSKRTREE_H
#define __NL_NLSKRTREE_H

/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "include/core/SkBBHFactory.h"
#include "include/core/SkMatrix.h"
#include "include/core/SkRect.h"
#include <skia-extension/GLPoint.hpp>

namespace graphikos {
namespace painter {
struct GLPoint;
}
}

/**
 * An R-Tree implementation. In short, it is a balanced n-ary tree containing a hierarchy of
 * bounding rectangles.
 *
 * It only supports bulk-loading, i.e. creation from a batch of bounding rectangles.
 * This performs a bottom-up bulk load using the STR (sort-tile-recursive) algorithm.
 *
 * TODO: Experiment with other bulk-load algorithms (in particular the Hilbert pack variant,
 * which groups rects by position on the Hilbert curve, is probably worth a look). There also
 * exist top-down bulk load variants (VAMSplit, TopDownGreedy, etc).
 *
 * For more details see:
 *
 *  Beckmann, N.; Kriegel, H. P.; Schneider, R.; Seeger, B. (1990). "The R*-tree:
 *      an efficient and robust access method for points and rectangles"
 */
class NLSkRTree {
public:
    NLSkRTree();

    void insert(const SkRect[], int N);
    void search(const SkRect& query, std::vector<int>* results) const;
    void search(const graphikos::painter::GLPoint point, std::vector<int>* results, SkScalar offset = 0) const;
    void searchRange(const SkRect& query, std::vector<int>* results) const;

    size_t bytesUsed() const;

    // Methods and constants below here are only public for tests.

    // Return the depth of the tree structure.
    int getDepth() const { return fCount ? fRoot.fSubtree->fLevel + 1 : 0; }
    // Insertion count (not overall node count, which may be greater).
    int getCount() const { return fCount; }

    // These values were empirically determined to produce reasonable performance in most cases.
    static const int kMinChildren = 6,
                     kMaxChildren = 11;

private:
    struct Node;

    struct Branch {
        union {
            Node* fSubtree;
            int fOpIndex;
        };
        SkRect fBounds;
    };

    struct Node {
        uint16_t fNumChildren;
        uint16_t fLevel;
        Branch fChildren[kMaxChildren];
    };

    void search(Node* root, const SkRect& query, std::vector<int>* results) const;
    void searchRange(Node* root, const SkRect& query, std::vector<int>* results) const;

    void search(Node* node, const graphikos::painter::GLPoint point, std::vector<int>* results, SkScalar offset = 0) const;

    // Consumes the input array.
    Branch bulkLoad(std::vector<Branch>* branches, int level = 0);

    // How many times will bulkLoad() call allocateNodeAtLevel()?
    static int CountNodes(int branches);

    Node* allocateNodeAtLevel(uint16_t level);

    // This is the count of data elements (rather than total nodes in the tree)
    int fCount;
    Branch fRoot;
    std::vector<Node> fNodes;
};

#endif
