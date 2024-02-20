import SwiftUI

struct PracticeView: View {
    @State private var bpm: Int = 60
    @State private var isRunning: Bool = false
    @State private var firstRhythm: Int = 2
    @State private var secondRhythm: Int = 4
    @State private var startAnimation: Bool = false
    @State private var startDate: Date?
        
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                RegularPolygon(sides: firstRhythm)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(.blue)
                RegularPolygon(sides: secondRhythm)
                    .stroke(lineWidth: 3)
                    .foregroundStyle(.red)
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundStyle(.white)
                    .frame(width: 400, height: 400)
                if isRunning {
                    Circle()
                        .foregroundColor(.white)
                        .offset(y: -200)
                        .frame(width: 24, height: 24)
                        .rotationEffect(.degrees(startAnimation ? 360 : 0))
                        .animation(.linear(duration: 60 * 4 / (Double(bpm))).repeatForever(autoreverses: false), value: startAnimation)
                        .onAppear { startAnimation = true }
                }
            }
            .frame(width: 400, height: 400)
            
            Spacer()
            
            if !isRunning {
                HStack {
                    VStack {
                        Text("Choose a BPM (speed):")
                            .font(.title3)
                        Picker("Select BPM", selection: $bpm) {
                            ForEach(40...120, id: \.self) { value in
                                Text("\(value)")
                                    .tag(value)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.black)
                    }
                    
                    VStack {
                        Text("Choose polyrhythm basis:")
                            .font(.title3)
                        HStack {
                            Picker("First rhythm", selection: $firstRhythm) {
                                ForEach(1...10, id: \.self) { value in
                                    Text("\(value)")
                                        .tag(value)
                                }
                            }
                            .pickerStyle(.wheel)
                            
                            Text(":")
                            
                            Picker("Second rhythm", selection: $secondRhythm) {
                                ForEach(1...10, id: \.self) { value in
                                    Text("\(value)")
                                        .tag(value)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.black)
                    }
                }
            } else {
                HStack {
                    Button {
                        checkTiming(isLeft: true)
                    } label: {
                        Circle()
                            .foregroundStyle(.blue)
                            .frame(maxWidth: 240)
                    }
                    .disabled(!isRunning)
                    Spacer()
                    Button {
                        checkTiming(isLeft: false)
                    } label: {
                        Circle()
                            .foregroundStyle(.red)
                            .frame(maxWidth: 240)
                    }
                    .disabled(!isRunning)
                }
                .padding(32)
            }
            
            Spacer()
            
            Button {
                isRunning.toggle()
                if isRunning {
                    startDate = Date()
                    SoundManager.instance.playSoundLoop(sound: .left, bpm: bpm, loops: firstRhythm)
                    SoundManager.instance.playSoundLoop(sound: .right, bpm: bpm, loops: secondRhythm)
                } else {
                    SoundManager.instance.stopSound()
                    startAnimation = false
                }
            } label: {
                Text(isRunning ? "Stop" : "Start")
                    .font(.title)
            }
        }
        .onAppear {
//            SoundManager.instance.initPlayers()
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 64)
    }
    
    func checkTiming(isLeft: Bool) -> Void {
        var interval: Int
        if isLeft {
            interval = 60 * 4 * 1000 / (bpm * firstRhythm)
        } else {
            interval = 60 * 4 * 1000 / (bpm * secondRhythm)
        }
//        print(interval)
        let distance = Int(Date().timeIntervalSince(startDate!) * 1000)
        let offset = min(distance % interval, abs(interval - distance % interval))
//        print(distance % interval)
//        print(interval - distance % interval)
        if offset <= 200 {
            print("Timing bom! L")
        } else if offset > 200 && offset <= 400 {
            print("Timing médio! L")
        } else {
            print("Timing ruim! L")
        }
    }
}

#Preview {
    PracticeView()
}
