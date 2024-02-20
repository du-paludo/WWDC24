import Foundation
import AVKit

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let instance = SoundManager()
    
    var availableLeftPlayers = [AVAudioPlayer?]()
    var busyLeftPlayers = [AVAudioPlayer?]()
    var availableRightPlayers = [AVAudioPlayer?]()
    var busyRightPlayers = [AVAudioPlayer?]()
    var leftTimer: Timer?
    var rightTimer: Timer?
    
    var birdPlayers = [SoundOptions : AVAudioPlayer]()
    
    var mariaCavaleiraPlayers = [AVAudioPlayer]()
    var picaPauPlayers = [AVAudioPlayer]()
    
    func initPlayers() {
        // Starts the left side audio players
        guard let url = Bundle.main.url(forResource: SoundOptions.left.rawValue, withExtension: ".m4a") else { return }
        do {
            for _ in 1...4 {
                let newPlayer = try AVAudioPlayer(contentsOf: url)
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
    
    func playSound(sound: SoundOptions) {
        let player = birdPlayers[sound]
        player?.play()
    }
    
    func stopSounds() {
        for player in birdPlayers {
            player.value.stop()
        }
    }
    
    func playBeat(sound: SoundOptions, player: Int) {
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
    
    func stopSound() {
        leftTimer?.invalidate()
        rightTimer?.invalidate()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if busyLeftPlayers.contains(where: {$0 == player}) {
            busyLeftPlayers.removeAll(where: {$0 == player})
            availableLeftPlayers.append(player)
        } else {
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
