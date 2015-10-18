//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/15/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerDelegate : class {
    func soundFinished(sender : AnyObject)
}

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmuchButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var selectOption: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    weak var delegate : PlayerDelegate?
    
    var isSlowPressed = false
    var isFastPressed = false
    var isChipPressed = false
    var isVadePressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: nil)
        } catch{
            
        }
        
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
       
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        selectOption.alpha = 0
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            
            self.selectOption.center.y = self.selectOption.frame.origin.y - 40
            self.selectOption.alpha = 1
            
            }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func playSlow(sender: UIButton) {
        
        if isSlowPressed == false {
            
            slowButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            audioPlayer.delegate = nil
            audioPlayer.stop()
            audioPlayer.rate = 0.5
            audioPlayer.currentTime = 0.0
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isSlowPressed = true
            
        } else {
            
            slowButton.setImage(UIImage(named: "slow"), forState: UIControlState.Normal)
            
            audioPlayer.stop()
            isSlowPressed = false
        }
        
    }
    
    @IBAction func playFast(sender: UIButton) {
        
        if isFastPressed == false {
            
            fastButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            audioPlayer.delegate = nil
            audioPlayer.stop()
            audioPlayer.rate = 2.0
            audioPlayer.currentTime = 0.0
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isFastPressed = true
            
        } else {
            
            fastButton.setImage(UIImage(named: "fast"), forState: UIControlState.Normal)
            
            audioPlayer.stop()
            isFastPressed = false
        }
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        
        if isChipPressed == false {
            
            chipmuchButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            isChipPressed = true
            
            playAudioWithVariablePitch(1000)
            
        } else {
            
            chipmuchButton.setImage(UIImage(named: "chipmunk"), forState: UIControlState.Normal)
            
            audioEngine.stop()
            audioEngine.reset()
            isChipPressed = false
        }
        
    }
    
    @IBAction func playVader(sender: UIButton) {
        
        if isVadePressed == false {
            
            vaderButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            isVadePressed = true
            
            playAudioWithVariablePitch(-1000)
            
        } else {
            
            vaderButton.setImage(UIImage(named: "vader"), forState: UIControlState.Normal)
            
            audioEngine.stop()
            audioEngine.reset()
            isVadePressed = false
        }
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            
            if self.isVadePressed == true {
                self.audioEngine.stop()
                self.vaderButton.setImage(UIImage(named: "vader"), forState: UIControlState.Normal)
                self.isVadePressed = false
            }
            
            if self.isChipPressed == true {
                self.audioEngine.stop()
                self.chipmuchButton.setImage(UIImage(named: "chipmunk"), forState: UIControlState.Normal)
                self.isChipPressed = false
            }
            
        })
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.delegate?.soundFinished(self)
        
        if isFastPressed == true {
            fastButton.setImage(UIImage(named: "fast"), forState: UIControlState.Normal)
            
            audioPlayer.stop()
            isFastPressed = false
        }
        
        if isSlowPressed == true {
            slowButton.setImage(UIImage(named: "slow"), forState: UIControlState.Normal)
            
            audioPlayer.stop()
            isSlowPressed = false
        }
    }
    
    func stop () {
        audioPlayer.stop()
    }
    
    deinit {
        audioPlayer.delegate = nil
    }
}
