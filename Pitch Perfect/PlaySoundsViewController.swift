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
    var audioPlayerEcho:AVAudioPlayer!
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
    
    let N:Int = 5
    
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
        
        initViewValues()
        
        initViewAnimation()
        
        screenOffsets()
        
        /*!
        *
        * @brief Setting AudioPlayer, AudioEngine and Echo Style
        *
        */
        
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
       
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        for i in 0...N {
            do{
            audioPlayerEcho = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl,
                fileTypeHint: nil)
                reverbPlayers.append(audioPlayerEcho)
            } catch {
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        switchButtonState()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        
        if isSlowPressed == false {
            
            slowButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            playWithRate(0.5)
            
            isSlowPressed = true
            
        } else {
            
            slowButton.setImage(UIImage(named: "slow"), forState: UIControlState.Normal)
            
            stop()
            isSlowPressed = false
        }
        
    }
    
    @IBAction func playFast(sender: UIButton) {
        
        if isFastPressed == false {
            
            fastButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            playWithRate(2.0)
            
            isFastPressed = true
            
        } else {
            
            fastButton.setImage(UIImage(named: "fast"), forState: UIControlState.Normal)
            
            stop()
            isFastPressed = false
        }
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        
        if isChipPressed == false {
            
            chipmunkButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            playAudioWithVariablePitch(1000)
            
            isChipPressed = true
            
        } else {
            
            chipmunkButton.setImage(UIImage(named: "chipmunk"), forState: UIControlState.Normal)
            
            stop()
            isChipPressed = false
        }
        
    }
    
    @IBAction func playVader(sender: UIButton) {
        
        if isVadePressed == false {
            
            vaderButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            playAudioWithVariablePitch(-1000)
            
            isVadePressed = true
            
        } else {
            
            vaderButton.setImage(UIImage(named: "vader"), forState: UIControlState.Normal)
            stop()
            isVadePressed = false
        }
        
    }
    
    @IBAction func playEcho(sender: UIButton) {
        
        if isEchoPressed == false {
            
            echoButton.setImage(UIImage(named: "stop audio"), forState: UIControlState.Normal)
            
            playWithEcho()
            
            isEchoPressed = true
            
        } else {
            
            stop()
            
            isEchoPressed = false
            echoButton.setImage(UIImage(named: "echo"), forState: UIControlState.Normal)

        }
        
    }
    
    func playWithEcho() {
        
        let delay:NSTimeInterval = 0.02
    
        for i in 0...N {
            let curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            audioPlayerEcho = reverbPlayers[i]
            audioPlayerEcho.delegate = nil
            stop()
            let exponent:Double = -Double(i)/Double(N/2)
            let volume = Float(pow(Double(M_E), exponent))
            audioPlayerEcho.volume = volume
            audioPlayerEcho.delegate = self
            
            audioPlayerEcho.playAtTime(audioPlayerEcho.deviceCurrentTime + curDelay)
        }
        
    }
    
    func playWithRate(rate: Float) {
        
        stop()
        
        audioPlayer.delegate = nil
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.delegate = self
        audioPlayer.play()
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stop()
        
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
                
                self.switchButtonState()
                
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
        
        switchButtonState()
        
    }
    
    func stop() {
        
        if audioEngine.running {
            audioEngine.reset()
            audioEngine.stop()
            switchButtonState()
        } else if audioPlayer.playing {
            audioPlayer.stop()
            switchButtonState()
        } else if audioPlayerEcho.playing && audioPlayerEcho != nil {
            for i in 0...N{
                audioPlayerEcho = reverbPlayers[i]
                audioPlayerEcho.currentTime = 0.0
                audioPlayerEcho.stop()
                switchButtonState()
            }
        }
    }
    
    deinit {
        audioPlayer.delegate = nil
    }
    
    func switchButtonState() {
        
        if isFastPressed == true {
            fastButton.setImage(UIImage(named: "fast"), forState: UIControlState.Normal)
            
            stop()
            isFastPressed = false
        }
        
        if isSlowPressed == true {
            slowButton.setImage(UIImage(named: "slow"), forState: UIControlState.Normal)
            
            stop()
            isSlowPressed = false
        }
        
        if isEchoPressed == true {
            echoButton.setImage(UIImage(named: "echo"), forState: UIControlState.Normal)
            
            stop()
            isEchoPressed = false
        }
        
        if isVadePressed == true {
            vaderButton.setImage(UIImage(named: "vader"), forState: UIControlState.Normal)
            
            stop()
            isVadePressed = false
        }
        
        if isChipPressed == true {
            chipmunkButton.setImage(UIImage(named: "chipmunk"), forState: UIControlState.Normal)
            
            stop()
            isChipPressed = false
        }
        
    }
    
    /*!
    *
    * @brief Setting the initial state for the fadeIn + Scale animation
    * Buttons will appear with a subtle animation.
    *
    */
    
    func initViewValues() {
        
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
    }
    
    /*!
    *
    * @brief Setting fadeIn + Scale for a subtle animation
    * Image resize for iPhone 4s or less
    *
    */
    
    func initViewAnimation() {
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
    
    func screenOffsets() {
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
    }
    
}
