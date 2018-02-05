//
//  Speak.swift
//  telecycle
//
//  Created by yoojonghyun on 2017. 12. 23..
//  Copyright © 2017년 yoojonghyun. All rights reserved.
//

import Foundation
import AVFoundation

final class Speaker {
    static let shareInstance = Speaker()
    let synthesizer = AVSpeechSynthesizer()
    lazy var audioSession = AVAudioSession()
    var lastSpeedSpeaked = 0
    var lastDistanceSpeakded = 0
    
    
    
    private init() {
        
        guard let _ = try? audioSession.setCategory(AVAudioSessionCategoryPlayback) else {
            print("error setting av session")
            return
        }
    }
    
    func speakIfNeeded(speed : Int, distance : Int) {
        if(isNeededSpeakingSpeed(speed: speed)) {
            lastSpeedSpeaked = speed
            speakString(header : "speed", number : String(speed), tailer : "")
        }
        
        if(isNeededSpeakingDistance(distance: distance)) {
            lastDistanceSpeakded = distance
            speakString(header : "distance", number : String(distance), tailer : "")
        }

    }
    
    func isNeededSpeakingSpeed(speed : Int) -> Bool {
        let condition = Int(lastSpeedSpeaked / 3) != Int(speed / 3)
        
        return condition
    }
    
    func isNeededSpeakingDistance(distance : Int) -> Bool {
        let condition = Int(lastDistanceSpeakded / 50) != Int(distance / 50)
        return condition
    }

    
    func speakString(header : String, number : String, tailer : String) {
        
        let utterance = AVSpeechUtterance(string: header + "," + number + "," + tailer)
//        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        
        synthesizer.speak(utterance)
        
    }
}
