import Foundation
import SwiftUI

struct RegularPolygon: Shape {
    var sides: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let offsetAngle = -90 * (Double.pi / 180)
        let initialX = center.x + CGFloat(cos(offsetAngle)) * radius
        let initialY = center.y + CGFloat(sin(offsetAngle)) * radius
        path.move(to: CGPoint(x: initialX, y: initialY))
        
        // Add lines to form the polygon
        for side in 1..<sides {
            let angle = (Double(side) * 2 * .pi / Double(sides)) + offsetAngle
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.closeSubpath()
        
        return path
    }
}
