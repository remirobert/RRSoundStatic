# RRSoundStatic
Library to manage communication with ultra sound on iOS

Work in **Swift** and **Objective-c**.

This is a wrapper for the lib sinvoice made during an Hackathon 😀.
![img_0182](https://cloud.githubusercontent.com/assets/3276768/14597891/11b479ba-0582-11e6-9555-61ba8b52764b.gif)

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
