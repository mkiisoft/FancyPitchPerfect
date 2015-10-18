//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/13/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordImage: UIButton!
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    var recordState = false
    var timerCount = 0.0
    var timer = NSTimer()
    
    var secondScreen: String = "secondScreen"
    var segueShouldOccur = false
    
    func CountTimer(){
        timerCount += 0.1
        let recordTimeFormat: String = NSString(format: "%05.2f", timerCount) as String
        recordTime.text = recordTimeFormat.stringByReplacingOccurrencesOfString(".", withString: ":")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        recordingInProgress.alpha = 0
        recordTime.alpha = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        recordImage.alpha = 1
        recordingInProgress.alpha = 0
        recordTime.alpha = 0
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        if recordingInProgress.hidden == false {
            tapToRecord.hidden = false
            recordingInProgress.hidden = true
            recordTime.hidden = true
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
            recordImage.setImage(UIImage(named: "stop button"), forState: UIControlState.Normal)
            
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
               
                    self.recordingInProgress.center.y = self.recordingInProgress.frame.origin.y + 40
                    self.recordingInProgress.alpha = 1
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.8, animations: {
                self.recordTime.alpha = 1
            })
            
            UIView.animateWithDuration(0.8, delay: 0.0, options: [.CurveEaseIn, .Repeat, .Autoreverse, .AllowUserInteraction], animations: {
                    self.recordImage.alpha = 0.2
                }, completion: nil)
            
            if recordState == false {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("CountTimer"), userInfo: nil, repeats: true)
                recordState = true
            }
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let recordingName = "fancy_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("secondScreen", sender: recordedAudio)
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

