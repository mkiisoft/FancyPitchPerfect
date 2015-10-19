//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/15/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(var1: NSURL, var2: String) {
        
        self.filePathUrl = var1
        self.title = var2
        
    }
}