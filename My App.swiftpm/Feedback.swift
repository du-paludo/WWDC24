//
//  Feedback.swift
//  My App
//
//  Created by Eduardo Stefanel Paludo on 18/02/24.
//

import SwiftUI

enum Feedback {
    case perfect
    case good
    case miss
    
    var description: String {
        switch self {
        case .perfect: return "Perfect"
        case .good: return "Good"
        case .miss: return "Miss"
        }
    }
    
    var color: Color {
        switch self {
        case .perfect: return .green
        case .good: return .yellow
        case .miss: return .red
        }
    }
}
