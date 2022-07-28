//
//  AudioManager.swift
//  KnockKnock
//
//  Created by LeeJaehoon on 2022/07/24.
//

import AVFoundation
import UIKit

class AudioManager {
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    
    func playSound(_ soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
}
