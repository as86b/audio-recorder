//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Austin Sizemore on 4/11/19.
//  Copyright © 2019 Austin Sizemore. All rights reserved.
//

import UIKit
import AVKit

//Mentioned from notes to have these protocols
//How to conform to protocols?
class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    //From tutorial
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Buttons need to be originally false until user gives permission
        recordButton.isEnabled = false
        playButton.isEnabled = false
        
        //Privacy setting put it Info.plist
        //Asking for permission to record
        recordingSession = AVAudioSession.sharedInstance()
        
        //Code in brackets is a trailing closure
        recordingSession.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                _ = UIAlertController(title: "Recording permission", message: "Permission was given", preferredStyle: .alert)
                
                print("Permission was allowed")
                
                self.recordButton.isEnabled = true
                self.playButton.isEnabled = true
            }
            else {
                _ = UIAlertController(title: "Recording permission", message: "Permission was not given", preferredStyle: .alert)
                
                print("Permission was not allowed")
                
                return
            }
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
//        We are wanting to record
        if(recordButton.image == UIImage(named: "record")) {
            
            recordButton.image = UIImage(named: "stop")
            
            playButton.isEnabled = false
            
            //Start recording
            audioRecorder.record()
            
        }
        else if (recordButton.image == UIImage(named: "stop")) {
        
            recordButton.image = UIImage(named: "record")
            
            playButton.isEnabled = true
            
            //Stop recording
            audioRecorder.stop()
        }
        else {
            print("Something went very wrong")
        }
        
        
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        //Recording was paused so we want to play it
        if(playButton.image == UIImage(named: "play")) {
            
            playButton.image = UIImage(named: "stop")
            
            recordButton.isEnabled = true
        
        }
        //Recording was playing so we want to pause it
        else if (playButton.image == UIImage(named: "stop")) {
            
            playButton.image = UIImage(named: "play")
            
            recordButton.isEnabled = false
        } else {
            print("Something went very wrong")
        }
        
//        guard let audioFile = audioFile else {
//            print("Cant play audio")
//            return
//        }
//        
//        guard let audioRec = audioRec, audioRec.isRecording == false else {
//            print("Cant play while recording")
//            return
//        }
//        
//        if let audioPlayer = audioPlayer {
//            if (audioPlayer.isPlaying) {
//                audioPlayer.stop()
//                playBarButton.image = UIImage(named: "play")
//                recordBarButton.isEnabled = true
//                return
//            }
//        }
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
//            audioPlayer?.delegate = (self as! AVAudioPlayerDelegate)
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//            recordBarButton.isEnabled = false
//            playBarButton.image = UIImage(named: "stop")
//        } catch {
//            print("error creating audio player")
//            return
//        }
    }
    
    
//    Might need to place this in some IBAction or something like that
    func startRecording() {
        
        //.caf file extenstion type as it uses Core Audio Format
        //.m4a was original type
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.caf")
        
        //From instructions
        let recordingSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: recordingSettings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
//             Record button switches to stop
        } else {
            //Record button is set to record icon
            // recording failed :(
        }
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

