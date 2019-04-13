//
//  ViewController.swift
//  Audio Capture and Playback
//
//  Created by Deng tianyuan on 4/12/19.
//  Copyright © 2019 Deng tianyuan. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordBar: UIBarButtonItem!
    @IBOutlet weak var playBar: UIBarButtonItem!
    
    var audioSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var fileManager: FileManager?
    var documentDirectoryURL: URL?
    var audioFileURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recordBar.isEnabled = false
        recordBar.isEnabled = false
        
        initFileSotrage()
        initAudioSession()
        
        audioSession?.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                self.recordBar.isEnabled = true
            } else {
                print("Cannot record audio.")
            }
        }
    }
    
    func initializeAudioRecorder() {
        let recordingSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        guard let audioFileURL = audioFileURL else {
            print("Error, no file URL is available.")
            return
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: audioFileURL, settings: recordingSettings)
            audioRecorder?.delegate = self
        } catch {
            print("Error initaializing the audio recorder")
        }
    }
    
    func initFileSotrage() {
        let fileManager = FileManager.default
        let documentDirectoryPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        documentDirectoryURL = documentDirectoryPaths[0]
        audioFileURL = documentDirectoryURL?.appendingPathComponent("audio.caf")
    }
    
    func initAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            print("audioSession error")
        }
    }


    @IBAction func recordBar(_ sender: Any) {
        if (recordBar.image == UIImage(named: "record")) {
            recordBar.image = UIImage(named: "stop")
            audioRecorder?.record()
        }else {
            audioRecorder?.stop()
            recordBar.image = UIImage(named: "record")
            playBar.isEnabled = true
        }
    }
    
    @IBAction func playBar(_ sender: Any) {
        guard let audioFileURL = audioFileURL else {
            print("Cant play audio")
            return
        }
        
        guard let audioRecorder = audioRecorder, audioRecorder.isRecording == false else {
            print("Cant play while recording")
            return
        }
        
        if let audioPlayer = audioPlayer {
            if (audioPlayer.isPlaying) {
                audioPlayer.stop()
                playBar.image = UIImage(named: "play")
                recordBar.isEnabled = true
                return
            }
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            recordBar.isEnabled = false
            playBar.image = UIImage(named: "stop")
        } catch {
            print("error unable to play")
            return
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBar.isEnabled = true
        playBar.image = UIImage(named: "play")
    }
}

