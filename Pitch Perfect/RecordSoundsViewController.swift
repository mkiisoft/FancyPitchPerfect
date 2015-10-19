//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/13/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordImage: UIButton!
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var pauseImage: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio = RecordedAudio()
    
    var recordState = false
    var isRecorderPaused = false
    var timerCount = 0.0
    var timer = NSTimer()
    
    var secondScreen: String = "secondScreen"
    var segueShouldOccur = false
    
    /*!
    *
    * @brief Setting counter with the update value and format
    *
    */
    
    func CountTimer(){
        timerCount += 0.1
        let recordTimeFormat: String = NSString(format: "%05.2f", timerCount) as String
        recordTime.text = recordTimeFormat.stringByReplacingOccurrencesOfString(".", withString: ":")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*!
        *
        * @brief Transparent NavigationBar with white title color
        *
        */
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        recordTime.alpha = 0
        tapToRecord.alpha = 0
        recordingInProgress.alpha = 0
        
        UIView.animateWithDuration(1.0, animations: {
            self.tapToRecord.alpha = 1
        })
    }
    
    /*!
    *
    * @brief Return animation values to previous/original state
    *
    */
    
    override func viewWillDisappear(animated: Bool) {
        recordImage.alpha = 1
        recordingInProgress.alpha = 0
        recordTime.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    /*!
    *
    * @brief Record audio function:
    *
    * - Record audio
    * - Starts the counter
    * - Starts all animations
    * - Change the image button
    * - When finish, return to previous state
    *
    */

    @IBAction func recordAudio(sender: UIButton) {
        
        if recordingInProgress.hidden == false {
            tapToRecord.hidden = false
            recordingInProgress.hidden = true
            recordTime.hidden = true
            pauseImage.hidden = true
            
            recordImage.setImage(UIImage(named: "microphone"), forState: UIControlState.Normal)
            
            if recordState == true {
                timer.invalidate()
                recordState = false
                timerCount = 0.0
                recordTime.text = "00:00"
            }
            
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
            
        } else {
            tapToRecord.hidden = true
            recordingInProgress.hidden = false
            recordTime.hidden = false
            pauseImage.hidden = false
            recordImage.setImage(UIImage(named: "stop button"), forState: UIControlState.Normal)
            
            pauseImage.transform = CGAffineTransformMakeScale(0.1, 0.1)
            pauseImage.alpha = 0
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
                
                self.pauseImage.alpha = 1
                self.pauseImage.transform = CGAffineTransformMakeScale(1, 1)
                
                }, completion: nil)
            
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
               
                    self.recordingInProgress.center.y = self.recordingInProgress.frame.origin.y + 40
                    self.recordingInProgress.alpha = 1
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, animations: {
                self.recordTime.alpha = 1
            })
            
            recordAnimation()
            
            if recordState == false {
                timerStarter()
                recordState = true
            }
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: recordedAudio.filePathUrl, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        
    }
    
    @IBAction func pauseRecord(sender: UIButton) {
        if isRecorderPaused == false {
            
            pauseImage.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            audioRecorder.pause()
            recordingInProgress.text = "paused"
            isRecorderPaused = true
            recordImage.enabled = false
            recordImage.layer.removeAllAnimations()
            
            timer.invalidate()
            
        } else {
            pauseImage.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            audioRecorder.record()
            recordingInProgress.text = "recording..."
            recordImage.enabled = true
            isRecorderPaused = false
            
            timerStarter()
            recordAnimation()
        }
    }
    
    func timerStarter() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("CountTimer"), userInfo: nil, repeats: true)
    }
    
    func recordAnimation(){
        
        self.recordImage.alpha = 1
        
        UIView.animateWithDuration(0.8, delay: 0.0, options: [.CurveEaseIn, .Repeat, .Autoreverse, .AllowUserInteraction], animations: {
            self.recordImage.alpha = 0.2
            }, completion: nil)
    }
    
    
    /*!
    *
    * @brief Waiting for OS to finish recording and segue to second screen
    *
    */
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegueWithIdentifier("secondScreen", sender: recordedAudio)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "secondScreen" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

}

