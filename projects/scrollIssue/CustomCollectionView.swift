//
//  CustomCollectionView.swift
//  scrollIssue
//
//  Created by kunguma-14252 on 17/08/23.
//

import Cocoa

class CustomCollectionView: NSCollectionView {
    
    override func setFrameSize(_ newSize: NSSize) {
        let size = self.collectionViewLayout?.collectionViewContentSize ?? newSize
        super.setFrameSize(size)
        if let scrollView = self.enclosingScrollView {
            scrollView.hasHorizontalScroller = size.width > scrollView.frame.width
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
