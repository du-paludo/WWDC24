//
//  StatisticsView.swift
//  My App
//
//  Created by Eduardo Stefanel Paludo on 19/02/24.
//

import SwiftUI

struct StatisticsView: View {
    @Binding var showStatics: Bool
    let precision: Double
    let rightNotes: Int
    let numberOfNotes: Int
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            ZStack {
                Rectangle()
                    .frame(width: 500, height: 380)
                    .foregroundStyle(.white)
                Rectangle()
                    .frame(width: 480, height: 360)
                    .foregroundStyle(Color(hex: "#E8E6B8"))
                VStack(spacing: 8) {
                    Text("Congrats!")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#663F1B"))
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text("Correct notes")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                        Spacer()
                        Text("\(rightNotes)/\(numberOfNotes)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                    }
                    HStack(alignment: .center) {
                        Text("Precision")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                        Spacer()
                        Text("\(Int(precision*100))%")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                    }
                    
                    Spacer()
                    
                    Button {
                        showStatics = false
                    } label: {
                        Text("Close")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                            .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 48)
            }
            .frame(width: 480, height: 360)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    StatisticsView(showStatics: .constant(true), precision: 2, rightNotes: 2, numberOfNotes: 2)
}
