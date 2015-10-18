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
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var chipmunkTop: NSLayoutConstraint!
    
    @IBOutlet weak var vaderTop: NSLayoutConstraint!
    var audioPlayer = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var reverbPlayers:[AVAudioPlayer] = []
    
    weak var delegate : PlayerDelegate?
    
    var isSlowPressed = false
    var isFastPressed = false
    var isChipPressed = false
    var isVadePressed = false
    var isEchoPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*!
        *
        * @brief Setting white title button
        *
        */
        

        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        /*!
        *
        * @brief Setting gradient background for the entire view/screen
        *
        */
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: nil)
        } catch{
            
        }
        
        /*!
        *
        * @brief Setting the initial state for the fadeIn + Scale animation
        * Buttons will appear with a subtle animation.
        *
        */
        
        slowButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        slowButton.alpha = 0
        
        fastButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        fastButton.alpha = 0
        
        chipmunkButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        chipmunkButton.alpha = 0
        
        vaderButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        vaderButton.alpha = 0
        
        echoButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        echoButton.alpha = 0
        
        /*!
        *
        * @brief Setting offset to buttons depending on screen device height
        *
        * 568.0 for iPhone 4s or less
        * 667.0 for iPhone 6
        * 736.0 for iPhone 6 Plus
        * else  for iPhone 5/5s
        *
        */
        
        if UIScreen.mainScreen().bounds.size.height < 568.0 {
            chipmunkTop.constant = -4
            vaderTop.constant = -4
        } else if UIScreen.mainScreen().bounds.size.height == 667.0 {
            chipmunkTop.constant = +80
            vaderTop.constant = +80
        } else if UIScreen.mainScreen().bounds.size.height == 736.0 {
            chipmunkTop.constant = +110
            vaderTop.constant = +110
        } else {
            
        }
        
        /*!
        *
        * @brief Setting AudioPlayer, AudioEngine and Echo Style
        *
        */
        
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
       
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        for i in 0...10 {
            do{
            let temp = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl,
                fileTypeHint: nil)
                reverbPlayers.append(temp)
            } catch {
                
            }
        }
        
        /*!
        *
        * @brief Setting fadeIn + Scale for a subtle animation
        * Image resize for iPhone 4s or less
        *
        */
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            
            self.slowButton.alpha = 1
            
            if UIScreen.mainScreen().bounds.size.height < 568.0 {
                self.slowButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            } else {
                self.slowButton.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            
            self.fastButton.alpha = 1
            
            if UIScreen.mainScreen().bounds.size.height < 568.0 {
                self.fastButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            } else {
                self.fastButton.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.2, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            
            self.chipmunkButton.alpha = 1
            
            if UIScreen.mainScreen().bounds.size.height < 568.0 {
                self.chipmunkButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            } else {
                self.chipmunkButton.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            
            self.vaderButton.alpha = 1
            
            if UIScreen.mainScreen().bounds.size.height < 568.0 {
                self.vaderButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            } else {
                self.vaderButton.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.8, delay: 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
            
            self.echoButton.alpha = 1
            
            if UIScreen.mainScreen().bounds.size.height < 568.0 {
                self.echoButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
            } else {
                self.echoButton.transform = CGAffineTransformMakeScale(1, 1)
            }
            
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
            
            chipmunkButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            isChipPressed = true
            
            playAudioWithVariablePitch(1000)
            
        } else {
            
            chipmunkButton.setImage(UIImage(named: "chipmunk"), forState: UIControlState.Normal)
            
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
    
    @IBAction func playEcho(sender: UIButton) {
        
        if isEchoPressed == false {
            
            echoButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            let delay:NSTimeInterval = 0.02
            for i in 0...10 {
                let curDelay:NSTimeInterval = delay*NSTimeInterval(i)
                let player:AVAudioPlayer = reverbPlayers[i]
                player.delegate = nil
                let exponent:Double = -Double(i)/Double(10/2)
                let volume = Float(pow(Double(M_E), exponent))
                player.volume = volume
                player.delegate = self
                player.playAtTime(player.deviceCurrentTime + curDelay)
            }
            
            isEchoPressed = true
            
        } else {
            
            echoButton.setImage(UIImage(named: "echo"), forState: UIControlState.Normal)
            
            audioPlayer.stop()
            isEchoPressed = false
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
        
        /*!
        *
        * @brief completionHandler to comeback the button to original state
        *
        */
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                
                if self.isVadePressed == true {
                    self.audioEngine.stop()
                    self.vaderButton.setImage(UIImage(named: "vader"), forState: UIControlState.Normal)
                    self.isVadePressed = false
                }
                
                if self.isChipPressed == true {
                    self.audioEngine.stop()
                    self.chipmunkButton.setImage(UIImage(named: "chipmunk"), forState: UIControlState.Normal)
                    self.isChipPressed = false
                }
                
            }
            
        })
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    /*!
    *
    * @brief delegate to comeback the button to original state
    *
    */
    
    
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
        
        if isEchoPressed == true {
            echoButton.setImage(UIImage(named: "echo"), forState: UIControlState.Normal)
            
            audioPlayer.stop()
            isEchoPressed = false
        }
    }
    
    func stop () {
        audioPlayer.stop()
    }
    
    deinit {
        audioPlayer.delegate = nil
    }
}
