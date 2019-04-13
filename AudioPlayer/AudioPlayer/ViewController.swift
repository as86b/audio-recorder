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
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
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
                //            print("Permission was allowed")
                
                self.recordButton.isEnabled = true
                self.playButton.isEnabled = true
            } else {
                _ = UIAlertController(title: "Recording permission", message: "Permission was not given", preferredStyle: .alert)
                //            print("Permission was not allowed")
                exit(0)
            }
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        if(recordButton.image == UIImage(named: "record")) {
            
            startRecording()
            
            playButton.isEnabled = false
        } else if (recordButton.image == UIImage(named: "stop")) {
            
        } else {
            print("Something went very wrong")
        }
        
        
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if(playButton.image == UIImage(named: "play")) {
            
            
            recordButton.isEnabled = false
        } else if (playButton.image == UIImage(named: "pause")) {
            
        } else {
            print("Something went very wrong")
        }
    }
    
    
//    Might need to place this in some IBAction or something like that
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
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
    
//  Note that AVAudioSession is a class and sharedInstance() is a class method. A class method is called directly on the class rather than on an instance of the class. The sharedInstance() provides a preconfigured AVAudioSession instance.
//    let audioSession = AVAudioSession.sharedInstance()
    
//    This might need to be in viewdidload if i use this instead to get it to work
    //requestRecordPremission is a function defined on the fly in the trailing closure
//    audioSession.requestRecordPermission() {
//        [unowned self] allowed in
//        if allowed {
//        // proceed to do whatever is needed to record
//        } else {
//        // don't let the app record because permission was denied
//        }
//    }
    
}

