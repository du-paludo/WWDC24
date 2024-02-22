import Foundation
import AVKit

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let instance = SoundManager()
    
    // Players used for bird song
    var birdPlayers = [SoundOptions : AVAudioPlayer]()
    
    // Players used for short bird sounds
    var mariaCavaleiraPlayers = [AVAudioPlayer]()
    var picaPauPlayers = [AVAudioPlayer]()
    
    // Players used for metronome sounds
    var availableLeftPlayers = [AVAudioPlayer?]()
    var busyLeftPlayers = [AVAudioPlayer?]()
    var availableRightPlayers = [AVAudioPlayer?]()
    var busyRightPlayers = [AVAudioPlayer?]()
    
    // Timer to play metronome sounds
    var leftTimer: Timer?
    var rightTimer: Timer?

    func initPlayers() {
        // Starts the left side audio players
        guard let url = Bundle.main.url(forResource: SoundOptions.left.rawValue, withExtension: ".m4a") else { return }
        do {
            for _ in 1...4 {
                let newPlayer = try AVAudioPlayer(contentsOf: url)
                newPlayer.prepareToPlay()
                availableLeftPlayers.append(newPlayer)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }

        // Starts the right side audio players
        guard let url = Bundle.main.url(forResource: SoundOptions.right.rawValue, withExtension: ".m4a") else { return }
        do {
            for _ in 1...10 {
                let newPlayer = try AVAudioPlayer(contentsOf: url)
                newPlayer.prepareToPlay()
                availableRightPlayers.append(newPlayer)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        // Starts the audio player for the complete sound of the short-crested flycatcher
        guard let url = Bundle.main.url(forResource: SoundOptions.mariaCavaleira.rawValue, withExtension: ".m4a") else { return }
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = -1
            newPlayer.prepareToPlay()
            birdPlayers[.mariaCavaleira] = newPlayer
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        // Starts the audio player for the complete sound of the green-barred woodpecker
        guard let url = Bundle.main.url(forResource: SoundOptions.picaPau.rawValue, withExtension: ".m4a") else { return }
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = -1
            newPlayer.prepareToPlay()
            birdPlayers[.picaPau] = newPlayer
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        // Starts the audio players for the short sound of the short-crested flycatcher
        guard let url = Bundle.main.url(forResource: SoundOptions.mariaCavaleiraShort.rawValue, withExtension: ".m4a") else { return }
        do {
            for _ in 1...3 {
                let newPlayer = try AVAudioPlayer(contentsOf: url)
                newPlayer.prepareToPlay()
                mariaCavaleiraPlayers.append(newPlayer)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
        // Starts the audio players for the short sound of the green-barred woodpecker
        guard let url = Bundle.main.url(forResource: SoundOptions.picaPauShort.rawValue, withExtension: ".m4a") else { return }
        do {
            for _ in 1...4 {
                let newPlayer = try AVAudioPlayer(contentsOf: url)
                newPlayer.prepareToPlay()
                picaPauPlayers.append(newPlayer)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Returns an existing audio players for metronome sounds or creates another one
    private func getAudioPlayer(sound: SoundOptions) -> AVAudioPlayer? {
        switch sound {
        case .left:
            if !availableLeftPlayers.isEmpty {
                return availableLeftPlayers.removeFirst()
            }
        case .right:
            if !availableRightPlayers.isEmpty {
                return availableRightPlayers.removeFirst()
            }
        default:
            break
        }
        
        guard let url = Bundle.main.url(
            forResource: sound.rawValue,
            withExtension: ".m4a"
        ) else {
            print("Fail to get url for \(sound)")
            return nil
        }
        
        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1
            return audioPlayer
        } catch {
            print("Fail to load \(sound)")
            return nil
        }
    }
    
    // Plays the full song of a bird
    func playBirdSong(sound: SoundOptions) {
        let player = birdPlayers[sound]
        player?.play()
    }
    
    // Playes a short bird sound
    func playBirdSound(sound: SoundOptions, player: Int) {
        switch sound {
        case .mariaCavaleiraShort:
            mariaCavaleiraPlayers[player].stop()
            mariaCavaleiraPlayers[player].play()
        case .picaPauShort:
            picaPauPlayers[player].stop()
            picaPauPlayers[player].play()
        default:
            break
        }
    }
    
    // Stop all bird sounds currently running
    func stopBirdSounds() {
        for player in birdPlayers {
            player.value.pause()
            player.value.currentTime = 0
        }
        for player in picaPauPlayers {
            player.pause()
            player.currentTime = 0
        }
        for player in mariaCavaleiraPlayers {
            player.pause()
            player.currentTime = 0
        }
    }
    
    // Starts a sound loop for the polyrhythm
    func playSoundLoop(sound: SoundOptions, bpm: Int, loops: Int) {
        switch sound {
        case .left:
            guard let player = self.getAudioPlayer(sound: .left) else { return }
            player.play()
            player.delegate = self
            self.busyLeftPlayers.append(player)
            leftTimer = Timer.scheduledTimer(withTimeInterval: (60 * 4 / (Double(bpm) * Double(loops))), repeats: true) { _ in
                guard let player = self.getAudioPlayer(sound: .left) else { return }
                player.play()
                player.delegate = self
                self.busyLeftPlayers.append(player)
            }
        case .right:
            guard let player = self.getAudioPlayer(sound: .right) else { return }
            player.play()
            player.delegate = self
            self.busyRightPlayers.append(player)
            rightTimer = Timer.scheduledTimer(withTimeInterval: (60 * 4 / (Double(bpm) * Double(loops))), repeats: true) { _ in
                guard let player = self.getAudioPlayer(sound: .right) else { return }
                player.play()
                player.delegate = self
                self.busyRightPlayers.append(player)
            }
        default:
            break
        }
    }
    
    // Stops the loops currently running
    func stopLoop() {
        leftTimer?.invalidate()
        rightTimer?.invalidate()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if busyLeftPlayers.contains(where: {$0 == player}) {
            busyLeftPlayers.removeAll(where: {$0 == player})
            availableLeftPlayers.append(player)
        } else if busyRightPlayers.contains(where: {$0 == player}) {
            busyRightPlayers.removeAll(where: {$0 == player})
            availableRightPlayers.append(player)
        }
    }
}

enum SoundOptions: String, CaseIterable {
    case left
    case right
    case mariaCavaleiraShort
    case mariaCavaleira
    case picaPauShort
    case picaPau
}
