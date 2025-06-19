//
//  FixedHeightPanelLayout.swift
//  YCT
//
//  Created by Lucky on 24/03/2024.
//

import Foundation
import FloatingPanel

class FixedHeightPanelLayout: FloatingPanelLayout {
    private var height: CGFloat = 0

    init(height: CGFloat) {
        self.height = height
    }

    public let position: FloatingPanelPosition = .bottom
    public let initialState: FloatingPanelState = .full
    public var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: height, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    @objc public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.7
    }
}
