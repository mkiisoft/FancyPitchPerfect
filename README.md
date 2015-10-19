# Fancy Pitch Perfect

This is the first project of the iOS Nanodegree from UDACITY. 100% Develop using Swift 2.0 and latest version of XCode v7.0.1

## Features:

- Audio Record
- Animations
- Audio Playback
- Audio Effects
- Auto Stop Playback

## Snippets:

- Animations:

EasyIn + FadeIn + Offset Y axis

```swift
UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
               
              self.recordingInProgress.center.y = self.recordingInProgress.frame.origin.y + 40
              self.recordingInProgress.alpha = 1
                
          }, completion: nil)
```
Infinite + AutoReverse Blink Animation

```swift
UIView.animateWithDuration(0.8, delay: 0.0, options: [.CurveEaseIn, .Repeat, .Autoreverse, .AllowUserInteraction], animations: {
                    self.recordImage.alpha = 0.2
                }, completion: nil)
```
- Gradient Background:
 
```swift
//
//  CAGradientLayer+Convience.swift
//  Pitch Perfect
//
//  Created by Mariano Zorrilla on 10/14/15.
//  Copyright © 2015 MkiiSoft. All rights reserved.
//

import UIKit

extension CAGradientLayer {

    func turquoiseColor() -> CAGradientLayer {
        
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocalization: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocalization
        
        return gradientLayer
        
    }
}
```
## Running App:

[![Fancy Pitch Perfect](https://i.ytimg.com/vi/p8L6OjUWoO8/maxresdefault.jpg)](https://www.youtube.com/watch?v=jfyIGGk2yBI "Fancy Pitch Perfect")
