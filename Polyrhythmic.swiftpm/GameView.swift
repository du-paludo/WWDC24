import SwiftUI

struct GameView: View {
    // Settings that player chooses
    @State private var bpm: Int = 60
    @State private var firstRhythm: Int = 3
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
    @State private var leftFeedbackTimer: Timer?
    @State private var rightFeedbackTimer: Timer?
    
    // Statistics
    @State var notesHit: Int = 0
    @State var rightNotes: Int = 0
    @State var leftFeedback: Feedback?
    @State var rightFeedback: Feedback?
    @State var feedbackCount = [Feedback : Int]()
    @State var showStatitics: Bool = false
    
    // User settings
    @State var numberOfCycles: Int = 4
    @State var practiceMode: Bool = false
    @State var hideCircle: Bool = false
    @State var disableSound: Bool = false
    
    // Show views
    @State var showSettings: Bool = false
    @State var showIntroduction: Bool = false
    
    var shouldDisable: Bool {
        let dateDifference = Date().timeIntervalSince(startDate ?? Date())
        let timeForAllCycles = Double(numberOfCycles) * 60*4/Double(bpm)
        print(dateDifference, timeForAllCycles - 0.2)
        return (!practiceMode && (dateDifference > timeForAllCycles - 0.2)) || !isRunning
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F5E2C6")
                .ignoresSafeArea()
            
            HStack {
                // Opens IntroductionView
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.white)
                    Image(systemName: "info")
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#227033"))
                }
                .onTapGesture {
                    showIntroduction = true
                    stopSetup()
                }
                .navigationDestination(isPresented: $showIntroduction) {
                    IntroductionView()
                }
                .onChange(of: showIntroduction) {
                    SoundManager.instance.stopBirdSounds()
                }
                
                Spacer()
                
                // Opens SettingsView
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.white)
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 38, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color(hex: "#227033"))
                }
                .onTapGesture {
                    showSettings = true
                    stopSetup()
                }
                .navigationDestination(isPresented: $showSettings) {
                    SettingsView(numberOfCycles: $numberOfCycles, practiceMode: $practiceMode, hideCircle: $hideCircle, disableSound: $disableSound)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            
            VStack(spacing: 16) {
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
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(hideCircle ? 0 : 1)
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
                            .animation(.linear(duration: (60 * 4 / Double(bpm))).repeatForever(autoreverses: false), value: startAnimation)
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
                        ZStack {
                            Image("rectangle2")
                                .resizable()
                                .scaledToFit()
                            VStack {
                                Text("Choose a BPM (speed):")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color(hex: "#663F1B"))
                                Picker("Select BPM", selection: $bpm) {
                                    ForEach(40...90, id: \.self) { value in
                                        Text("\(value)")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundStyle(Color(hex: "#663F1B"))
                                            .tag(value)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                            .padding(.horizontal, 48)
                        }
                        
                        ZStack {
                            Image("rectangle3")
                                .resizable()
                                .scaledToFit()
                            
                            VStack {
                                Text("Choose polyrhythm:")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color(hex: "#663F1B"))
                                HStack {
                                    Picker("First rhythm", selection: $firstRhythm) {
                                        ForEach(2...8, id: \.self) { value in
                                            Text("\(value)")
                                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                                .foregroundStyle(Color(hex: "#663F1B"))
                                                .tag(value)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    
                                    Text(":")
                                    
                                    Picker("Second rhythm", selection: $secondRhythm) {
                                        ForEach(2...8, id: \.self) { value in
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
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 48)
                } else {
                    VStack {
                        VStack {
                            if !startAnimation && !practiceMode {
                                Text("Press both buttons at the same time to start")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(hex: "#663F1B"))
                            } else {
                                HStack {
                                    VStack(alignment: .center) {
                                        if let lf = leftFeedback {
                                            Text(lf.description)
                                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                                .foregroundStyle(lf.color)
                                        }
                                    }
                                    .frame(maxWidth: 123)
                                    Spacer()
                                    VStack(alignment: .center) {
                                        if let rf = rightFeedback {
                                            Text(rf.description)
                                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                                .foregroundStyle(rf.color)
                                        }
                                    }
                                    .frame(maxWidth: 123)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 129)
                            }
                        }
                        .frame(height: 80)
                        
                        // Buttons to analyze timing
                        HStack {
                            Button {
                                if !practiceMode {
                                    if !startAnimation {
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
                                if !practiceMode {
                                    if !startAnimation {
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
                        .padding(.horizontal, 64)
                    }
                    .frame(maxHeight: .infinity)
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
                    showStatitics = true
                }
            }
        }
        .overlay {
            if showStatitics {
                StatisticsView(showStatics: $showStatitics, rightNotes: rightNotes, numberOfNotes: numberOfCycles*(firstRhythm + secondRhythm), feedbackCount: feedbackCount)
            }
        }
        .onAppear {
            cyclesLeft = numberOfCycles
        }
    }
    
    func startSetup() {
        countdownTimer = Timer.publish(every: TimeInterval(60*4/Double(bpm)), on: .main, in: .common).autoconnect()
//        Timer.scheduledTimer(withTimeInterval: (60 * 4 * 0.3 / (Double(bpm) * Double(firstRhythm))), repeats: false) { _ in
//            leftBlocked = false
//            leftTimer = Timer.scheduledTimer(withTimeInterval: (60 * 4 / (Double(bpm) * Double(firstRhythm))), repeats: true) { _ in
//                leftBlocked = false
//            }
//        }
//        Timer.scheduledTimer(withTimeInterval: (60 * 4 * 0.3 / (Double(bpm) * Double(secondRhythm))), repeats: false) { _ in
//            rightBlocked = false
//            rightTimer = Timer.scheduledTimer(withTimeInterval: (60 * 4 / (Double(bpm) * Double(secondRhythm))), repeats: true) { _ in
//                rightBlocked = false
//            }
//        }
        if !disableSound {
            SoundManager.instance.playSoundLoop(sound: .left, bpm: bpm, loops: firstRhythm)
            SoundManager.instance.playSoundLoop(sound: .right, bpm: bpm, loops: secondRhythm)
        }
        startDate = Date()
        notesHit = 0
        rightNotes = 0
        if !practiceMode {
            startAnimation = true
        }
        feedbackCount[.perfect] = 0
        feedbackCount[.good] = 0
        feedbackCount[.miss] = 0
    }
    
    func stopSetup() {
        isRunning = false
        SoundManager.instance.stopLoop()
        startAnimation = false
        cyclesLeft = numberOfCycles
        leftFeedback = nil
        rightFeedback = nil
//        leftTimer?.invalidate()
//        rightTimer?.invalidate()
    }
    
    func checkTiming(isLeft: Bool) -> Void {
        var interval: Int
        if isLeft {
            interval = 60 * 4 * 1000 / (bpm * firstRhythm)
        } else {
            interval = 60 * 4 * 1000 / (bpm * secondRhythm)
        }
        let distance = Int(Date().timeIntervalSince(startDate!) * 1000)
        let offset = min(distance % interval, abs(interval - distance % interval))
//        let relativeOffset = Double(offset)/Double(interval)
        if isLeft {
            leftFeedbackTimer?.invalidate()
            leftFeedbackTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                // Hide the feedback after the timer fires
                leftFeedback = nil
            }
            if offset > 300 {
                leftFeedback = .miss
                feedbackCount[.miss]! += 1
            } else if offset <= 150 {
                leftFeedback = .perfect
                feedbackCount[.perfect]! += 1
//                leftBlocked = true
                rightNotes += 1
            } else if offset > 150 && offset <= 300 {
                leftFeedback = .good
                feedbackCount[.good]! += 1
//                leftBlocked = true
                rightNotes += 1
            }
        } else if !isLeft {
            rightFeedbackTimer?.invalidate()
            rightFeedbackTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                // Hide the feedback after the timer fires
                rightFeedback = nil
            }
            if offset > 300 {
                rightFeedback = .miss
                feedbackCount[.miss]! += 1
            } else if offset <= 150 {
                rightFeedback = .perfect
                feedbackCount[.perfect]! += 1
//                rightBlocked = true
                rightNotes += 1
            } else if offset > 150 && offset <= 300 {
                rightFeedback = .good
                feedbackCount[.good]! += 1
//                rightBlocked = true
                rightNotes += 1
            }
        }
        notesHit += 1
    }
}

#Preview {
    GameView()
}
