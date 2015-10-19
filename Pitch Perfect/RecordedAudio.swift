//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/15/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL
    var title: String = "fancy_audio.wav"
    
    override init() {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let pathArray = [dirPath, title]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        filePathUrl = filePath!
    }
}