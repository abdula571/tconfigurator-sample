//
//  CCrossedLineLabel.swift
//  Sample
//
//  Created by Абдула Магомедов on 16.06.2022.
//

import UIKit

final class CCrossedLineLabel: UILabel {
    
    private let crossedLineLayer = CAShapeLayer()
    
    init(lineColor: UIColor? = UIColor.primary, lineWidth: CGFloat = 1) {
        super.init(frame: .zero)
        
        crossedLineLayer.strokeColor = lineColor?.cgColor
        crossedLineLayer.lineWidth = lineWidth
        
        layer.addSublayer(crossedLineLayer)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let capHeight = font?.capHeight else { return }
        
        let offset = (bounds.height - capHeight) / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.maxY - offset))
        path.addLine(to: CGPoint(x: bounds.maxX, y: offset))
        
        crossedLineLayer.path = path.cgPath
    }
}
