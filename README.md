# RRSoundStatic
Library to manage communication with ultra sound on iOS

Work in **Swift** and **Objective-c**.

# How to use

```swift
//send string with ultrasound
self.voiceSender.startPlay("salut") { 
  // string "salut" sent
}

//recognize string with ultrasound
self.voiceRecognizer.startRecord { string in
  // recorder string
}
```
