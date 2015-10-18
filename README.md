# FancyPitchPerfect

This is the first project of the iOS Nanodegree from UDACITY. 100% Develop using Swift 2.0 and latest version of XCode v7.0.1

## Features:

- Audio Record
- Animations
- Audio Playback
- Audio Effects
- Auto Stop Playback

## Snippets:

- Animations:

```swift
  UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: {
               
                    self.recordingInProgress.center.y = self.recordingInProgress.frame.origin.y + 40
                    self.recordingInProgress.alpha = 1
                
                }, completion: nil)
```

## Working App:

![alt tag](https://lh3.googleusercontent.com/-MiSs7Kn1z20/ViOqdoB0wcI/AAAAAAAAGdw/1j9MyTsue4s/w1786-h1116-no/fancy.png)
