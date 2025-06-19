//
//  YCTMarkerView.swift
//  YCT
//
//  Created by 木木木 on 2021/12/17.
//

import Foundation
import DGCharts
#if canImport(UIKit)
    import UIKit
#endif

public class YCTMarkerView: MarkerImage {
    
    static var boxInterval: CGFloat = 4
    static var boxWidth: CGFloat = 140
    static var boxHeight: CGFloat = 60
    
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    open var label: NSAttributedString?
    public var xAxisValueFormatter: AxisValueFormatter
    public var yFormatter: NumberFormatter
    
    @objc public init(font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                      xAxisValueFormatter: AxisValueFormatter, yFormatter: NumberFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        self.yFormatter = yFormatter
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        super.init()
    }
    
    open override func draw(context: CGContext, point: CGPoint) {
        guard let label = label, let chartView = chartView else { return }
        
        var offset = CGPoint.zero
        let chartSize = chartView.bounds.size
        let dotOffsetY: CGFloat = 20
        let dotOffsetX: CGFloat = 8
        let whiteDotRadius: CGFloat = 6
        
        if point.y + dotOffsetY + whiteDotRadius + Self.boxHeight / 2 > chartSize.height {
            offset.y = 0
        } else {
            offset.y = dotOffsetY
        }
        
        if point.x + dotOffsetX + Self.boxInterval + Self.boxWidth > chartSize.width {
            offset.x = -dotOffsetX
        } else {
            offset.x = dotOffsetX
        }
        
        context.saveGState()
        
        // 绘制圆
        let strokeColor = UIColor.white
        let fillColor = UIColor(red: 254/255.0, green: 43/255.0, blue: 84/255.0, alpha: 1)
        
        context.setLineWidth(2)
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(strokeColor.cgColor)
        context.addArc(center:
                        CGPoint(
                            x: point.x + offset.x + (offset.x > 0 ? whiteDotRadius : -whiteDotRadius),
                            y: point.y + offset.y + whiteDotRadius),
                       radius: whiteDotRadius,
                       startAngle: 0,
                       endAngle: 2 * CGFloat.pi,
                       clockwise: true)
        context.drawPath(using: .fillStroke)
        
        var boxRect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x + whiteDotRadius * 2 + Self.boxInterval,
                y: point.y + offset.y + whiteDotRadius - Self.boxHeight / 2),
            size: CGSize(
                width: Self.boxWidth,
                height: Self.boxHeight))
        
        if offset.x < 0 {
            var orgin = boxRect.origin
            orgin.x = point.x + offset.x - (whiteDotRadius * 2 + Self.boxInterval) - Self.boxWidth
            boxRect = CGRect(origin: orgin, size: boxRect.size)
        }
        
        let path = UIBezierPath(roundedRect: boxRect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(
                                    width: 5,
                                    height: 5))
        let shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        context.setFillColor(UIColor.white.cgColor)
        context.setShadow(offset: CGSize(width: 0, height: 4),
                          blur: 8,
                          color: shadowColor.cgColor)
        context.addPath(path.cgPath)
        context.drawPath(using: .fill)
        
        boxRect.origin.y += self.insets.top
        boxRect.origin.x += self.insets.left
        
        UIGraphicsPushContext(context)
        
        label.draw(in: boxRect)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setLabel(xAxisValueFormatter.stringForValue(entry.x, axis: nil),
                 label2: yFormatter.string(from: NSNumber(floatLiteral: entry.y))!)
    }
    
    @objc open func setLabel(_ label1: String, label2: String) {
        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paraStyle.lineSpacing = 8
        
        let attributedString = NSMutableAttributedString(string: label1 + "\n" + "播放量:" + label2)
        attributedString.setAttributes([
            .paragraphStyle: paraStyle,
            .font: self.font,
            .foregroundColor: self.textColor
        ], range: NSMakeRange(0, attributedString.length))
        attributedString.setAttributes([
            .foregroundColor: UIColor.lightGray
        ], range: NSMakeRange(label1.count + 1, 4))
        label = attributedString.copy() as? NSAttributedString
    }
}
