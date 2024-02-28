//
//  StatisticsView.swift
//  My App
//
//  Created by Eduardo Stefanel Paludo on 19/02/24.
//

import SwiftUI

struct StatisticsView: View {
    @Binding var showStatics: Bool
    let rightNotes: Int
    let numberOfNotes: Int
    let feedbackCount: [Feedback : Int]
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
            ZStack {
                Rectangle()
                    .frame(width: 440, height: 540)
                    .foregroundStyle(.white)
                Rectangle()
                    .frame(width: 420, height: 520)
                    .foregroundStyle(Color(hex: "#E8E6B8"))
                VStack(spacing: 8) {
                    Text("Statitics")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#663F1B"))
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text("Correct notes")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                        Spacer()
                        Text("\(min(rightNotes, numberOfNotes))/\(numberOfNotes)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                    }
                    HStack(alignment: .center) {
                        Text("Perfect")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(Feedback.perfect.color)
                        Spacer()
                        Text("x\(feedbackCount[.perfect] ?? 0)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                    }
                    
                    HStack(alignment: .center) {
                        Text("Good")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(Feedback.good.color)
                        Spacer()
                        Text("x\(feedbackCount[.good] ?? 0)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                    }
                    
                    HStack(alignment: .center) {
                        Text("Miss")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(Feedback.miss.color)
                        Spacer()
                        Text("x\(feedbackCount[.miss] ?? 0)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                    }
                    
                    Spacer()
                    
                    Button {
                        showStatics = false
                    } label: {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .regular, design: .rounded))
                                .foregroundStyle(.red)
                            Text("Close")
                                .font(.system(size: 24, weight: .regular, design: .rounded))
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 48)
            }
            .frame(width: 420, height: 520)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    StatisticsView(showStatics: .constant(true), rightNotes: 2, numberOfNotes: 2, feedbackCount: [.perfect:3, .good:5, .miss:4])
}
