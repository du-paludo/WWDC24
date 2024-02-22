//
//  SettingsView.swift
//  My App
//
//  Created by Eduardo Stefanel Paludo on 18/02/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var numberOfCycles: Int
    @Binding var practiceMode: Bool
    @Binding var hideCircle: Bool
    @Binding var disableSound: Bool
    
    var intProxy: Binding<Double>{
            Binding<Double>(get: {
                return Double(numberOfCycles)
            }, set: {
                numberOfCycles = Int($0)
            })
        }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 8) {
                Text("Number of cycles")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(hex: "#663F1B"))
                Spacer()
                Picker("Number of cycles", selection: $numberOfCycles) {
                    ForEach(1...10, id: \.self) { value in
                        Text("\(value)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "#663F1B"))
                            .tag(value)
                    }
                }
                .tint(Color(hex: "#663F1B"))
                .pickerStyle(.segmented)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle(isOn: $practiceMode, label: {
                    Text("Practice mode")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#663F1B"))
                })
                Text("Practice mode removes number of cycles limit and disables feedback")
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .foregroundStyle(Color(hex: "#663F1B"))
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle(isOn: $hideCircle, label: {
                    Text("Hide loop circle")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#663F1B"))
                })
                Toggle(isOn: $disableSound, label: {
                    Text("Disable sound")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#663F1B"))
                })
                Text("Enabling these options will make the game much more challenging, but also closer to how polyrhythms are used in music")
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .foregroundStyle(Color(hex: "#663F1B"))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
        .background {
            Color(hex: "#F5E2C6")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingsView(numberOfCycles: .constant(2), practiceMode: .constant(false), hideCircle: .constant(true), disableSound: .constant(true))
}
