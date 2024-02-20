import SwiftUI

struct GameView: View {
    // Settings that player chooses
    @State private var bpm: Int = 60
    @State private var firstRhythm: Int = 2
    @State private var secondRhythm: Int = 4
    
    // True if player has pressed start
    @State private var isRunning: Bool = false
    // True if player begins playing
    @State private var startAnimation: Bool = false
    
    // Used to keep track of cycles performed
    @State var countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var cyclesLeft: Int = 2
    
    // Used to analyze timing
    @State private var startDate: Date?
    @State var lastLeftTouch: Date?
    @State var lastRightTouch: Date?
    
    // Statistics
    @State var precision: Double = 0
    @State var notesHit: Int = 0
    @State var rightNotes: Int = 0
    @State var leftFeedback: Feedback?
    @State var rightFeedback: Feedback?
    @State var showStatics: Bool = false
    
    // User settings
    @State var numberOfCycles: Int = 1
    @State var practiceMode: Bool = false
    @State var hideCircle: Bool = false
    @State var disableSound: Bool = false
    
    var shouldDisable: Bool {
        let dateDifference = Date().timeIntervalSince(startDate ?? Date())
        let timeForAllCycles = Double(numberOfCycles) * 60*4/Double(bpm)
        //        print(dateDifference)
        //        print(timeForAllCycles - 0.2)
        return (!practiceMode && (dateDifference > timeForAllCycles - 0.2)) || !isRunning
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F5E2C6")
                .ignoresSafeArea()
            
            HStack {
                // Opens IntroductionView
                NavigationLink {
                    IntroductionView()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.white)
                        Image(systemName: "info")
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: "#227033"))
                    }
                }
                
                Spacer()
                
                // Opens SettingsView
                NavigationLink {
                    SettingsView(numberOfCycles: $numberOfCycles, practiceMode: $practiceMode, hideCircle: $hideCircle, disableSound: $disableSound)
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.white)
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(hex: "#227033"))
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            
            VStack(spacing: 32) {
                // Cycles remaining
                HStack(alignment: .bottom) {
                    Text(practiceMode ? "-" : "\(cyclesLeft)")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#663F1B"))
                    Text(" cycles remaining")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .offset(y: -3)
                        .foregroundStyle(Color(hex: "#663F1B"))
                }
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundStyle(.white)
                        .frame(width: 400, height: 400)
                    RegularPolygon(sides: firstRhythm)
                        .stroke(lineWidth: 10)
                        .foregroundStyle(Color(hex: "#84AF7C"))
                    RegularPolygon(sides: secondRhythm)
                        .stroke(lineWidth: 10)
                        .foregroundStyle(Color(hex: "#D1875D"))
                    
                    // If is running, show ball that loops around circle
                    if isRunning && !hideCircle {
                        Circle()
                            .foregroundColor(Color(hex: "#AD2525"))
                            .offset(y: -200)
                            .frame(width: 32, height: 32)
                            .rotationEffect(.degrees(startAnimation ? 360 : 0))
                            .animation(.linear(duration: 60 * 4 / (Double(bpm))).repeatForever(autoreverses: false), value: startAnimation)
                            .onAppear {
                                if practiceMode {
                                    startAnimation = true
                                }
                            }
                    }
                }
                .frame(width: 400, height: 400)
                
                Spacer()
                
                // If is not running, player must choose BPM and polyrhythm
                if !isRunning {
                    HStack {
                        VStack {
                            Text("Choose a BPM (speed):")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(hex: "#663F1B"))
                            Picker("Select BPM", selection: $bpm) {
                                ForEach(40...120, id: \.self) { value in
                                    Text("\(value)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color(hex: "#663F1B"))
                                        .tag(value)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        .padding(.horizontal, 48)
                        .background {
                            Image("rectangle2")
                                .resizable()
                                .scaledToFill()
                        }
                        
                        VStack {
                            Text("Choose polyrhythm:")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(hex: "#663F1B"))
                            HStack {
                                Picker("First rhythm", selection: $firstRhythm) {
                                    ForEach(1...10, id: \.self) { value in
                                        Text("\(value)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundStyle(Color(hex: "#663F1B"))
                                            .tag(value)
                                    }
                                }
                                .pickerStyle(.wheel)
                                
                                Text(":")
                                
                                Picker("Second rhythm", selection: $secondRhythm) {
                                    ForEach(1...10, id: \.self) { value in
                                        Text("\(value)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundStyle(Color(hex: "#663F1B"))
                                            .tag(value)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                        }
                        .padding(.horizontal, 48)
                        .background {
                            Image("rectangle3")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .padding(.horizontal, 48)
                } else {
                    VStack {
                        if !startAnimation && !practiceMode {
                            Text("Press both buttons at the same time to start")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "#663F1B"))
                        } else {
                            HStack {
                                VStack(alignment: .center) {
                                    if let leftFeedback {
                                        Text(leftFeedback.description)
                                            .font(.title)
                                            .foregroundStyle(leftFeedback.color)
                                    }
                                }
                                .padding(.trailing, 54)
                                .frame(maxWidth: .infinity)
                                VStack(alignment: .center) {
                                    if let rightFeedback {
                                        Text(rightFeedback.description)
                                            .font(.title)
                                            .foregroundStyle(rightFeedback.color)
                                    }
                                }
                                .padding(.leading, 54)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(height: 80)
                    
                    // Buttons to analyze timing
                    HStack {
                        Button {
                            if !shouldDisable {
                                if !startAnimation && !practiceMode {
                                    startSetup()
                                }
                                checkTiming(isLeft: true)
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: 260)
                                Circle()
                                    .foregroundStyle(Color(hex: "#84AF7C"))
                                    .frame(maxWidth: 240)
                            }
                        }
                        .disabled(shouldDisable)
                        Spacer()
                        Button {
                            if !shouldDisable {
                                if !startAnimation && !practiceMode {
                                    startSetup()
                                }
                                checkTiming(isLeft: false)
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: 260)
                                Circle()
                                    .foregroundStyle(Color(hex: "#D1875D"))
                                    .frame(maxWidth: 240)
                            }
                        }
                        .disabled(shouldDisable)
                    }
                    .padding(.horizontal, 32)
                }
                
                Spacer()
                
                Button {
                    if isRunning {
                        stopSetup()
                    } else {
                        isRunning = true
                        startDate = nil
                        if practiceMode {
                            startSetup()
                        }
                    }
                } label: {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#227033"))
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 32)
        }
        .onReceive(countdownTimer) { _ in
            if startAnimation && !practiceMode {
                if (cyclesLeft > 1) {
                    cyclesLeft -= 1
                } else {
                    stopSetup()
                }
            }
        }
        .overlay {
            if showStatics {
                StatisticsView(showStatics: $showStatics, precision: (precision/Double(notesHit)), rightNotes: rightNotes, numberOfNotes: numberOfCycles*(firstRhythm + secondRhythm))
            }
        }
        .onAppear {
            cyclesLeft = numberOfCycles
        }
    }
    
    func startSetup() {
        countdownTimer = Timer.publish(every: TimeInterval(60*4/Double(bpm)), on: .main, in: .common).autoconnect()
        if !disableSound {
            SoundManager.instance.playSoundLoop(sound: .left, bpm: bpm, loops: firstRhythm)
            SoundManager.instance.playSoundLoop(sound: .right, bpm: bpm, loops: secondRhythm)
        }
        startDate = Date()
        precision = 0
        notesHit = 0
        rightNotes = 0
        if !practiceMode {
            startAnimation = true
        }
    }
    
    func stopSetup() {
        isRunning = false
        SoundManager.instance.stopSound()
        startAnimation = false
        cyclesLeft = numberOfCycles
        leftFeedback = nil
        rightFeedback = nil
        if !practiceMode {
            showStatics = true
        }
    }
    
    func checkTiming(isLeft: Bool) -> Void {
        var interval: Int
        var timeFromLastTouch: Double
        if isLeft {
            interval = 60 * 4 * 1000 / (bpm * firstRhythm)
            timeFromLastTouch = Date().timeIntervalSince(lastLeftTouch ?? Date())
        } else {
            interval = 60 * 4 * 1000 / (bpm * secondRhythm)
            timeFromLastTouch = Date().timeIntervalSince(lastRightTouch ?? Date())
        }
        print(interval)
        let distance = Int(Date().timeIntervalSince(startDate!) * 1000)
        let offset = min(distance % interval, abs(interval - distance % interval))
        print(distance % interval)
        print(interval - distance % interval)
        let relativeOffset = Double(offset)/Double(interval)
        print(Double(offset)/Double(interval))
        if relativeOffset <= 0.150 {
            if isLeft {
                leftFeedback = .perfect
            } else {
                rightFeedback = .perfect
            }
            rightNotes += 1
        } else if relativeOffset > 0.150 && relativeOffset <= 0.300 {
            if isLeft {
                leftFeedback = .good
            } else {
                rightFeedback = .good
            }
            rightNotes += 1
        } else {
            if isLeft {
                leftFeedback = .miss
            } else {
                rightFeedback = .miss
            }
        }
        precision += Double(1 - relativeOffset)
        //            print(precision)
        notesHit += 1
    }
}

#Preview {
    GameView()
}
