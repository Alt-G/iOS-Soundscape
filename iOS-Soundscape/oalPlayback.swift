import UIKit
import AVFoundation

import OpenAL

typealias ALCcontext = COpaquePointer
typealias ALCdevice = COpaquePointer

let kDefaultDistance: Float = 25.0

@objc(oalPlayback_MultiTest)
class oalPlayback_MultiTest: NSObject {
    
    var sources = [ALuint](count: 2, repeatedValue: 0);
    var buffers = [ALuint](count: 2, repeatedValue: 0);
    var context: ALCcontext = nil
    var device: ALCdevice = nil
    
    var data: UnsafeMutablePointer<Void> = nil
    var data2: UnsafeMutablePointer<Void> = nil
    var sourceVolume: ALfloat = 0
    // Whether the sound is playing or stopped
    dynamic var isPlaying: Bool = false
    // Whether playback was interrupted by the system
    var wasInterrupted: Bool = false
    var iPodIsPlaying: Bool = false
    
    //MARK: Object Init / Maintenance
    override init() {
        super.init()
        // Start with our sound source slightly in front of the listener
        self._sourcePos = CGPointMake(0, 0)
        self._sourcePos2 = CGPointMake(400, 700)
        
        // Put the listener in the center of the stage
        self._listenerPos = CGPointMake(0.0, 0.0)
        
        // Listener looking straight ahead
        self._listenerRotation = 0.0
        
        wasInterrupted = false
        
        // Initialize our OpenAL environment
        self.initOpenAL()
        
    }
    
    deinit {
        self.teardownOpenAL()
    }
    
    //MARK: OpenAL
    
    private func initBuffer() {
        var format: ALenum = 0
        var size: ALsizei = 0
        var freq: ALsizei = 0
        
        var format2: ALenum = 0
        var size2: ALsizei = 0
        var freq2: ALsizei = 0
        
        let bundle = NSBundle.mainBundle()
        
        // get some audio data from a wave file
        let fileURL = NSURL(fileURLWithPath: bundle.pathForResource("rain_thunder", ofType: "caf")!)
        
        let fileURL2 = NSURL(fileURLWithPath: bundle.pathForResource("jungle_birds", ofType: "caf")!)
        
        //        if fileURL != nil {
        data = MyGetOpenALAudioData(fileURL, &size, &format, &freq)
        data2 = MyGetOpenALAudioData(fileURL2, &size2, &format2, &freq2)
        
        var error = alGetError()
        if error != AL_NO_ERROR {
            fatalError("error loading sound: \(error)\n")
        }
        
        // use the static buffer data API
        alBufferData(buffers[0], format, data, size, freq)
        alBufferData(buffers[1], format2, data2, size2, freq2)
        MyFreeOpenALAudioData(data, size)
        MyFreeOpenALAudioData(data2, size2)
        
        error = alGetError()
        if error != AL_NO_ERROR {
            NSLog("error attaching audio to buffer: \(error)\n")
        }
        //        } else {
        //            NSLog("Could not find file!\n")
        //        }
    }
    
    private func initSource() {
        var error: ALenum = AL_NO_ERROR
        alGetError() // Clear the error
        
        
        for i in 0...1 {
            // Turn Looping ON
            alSourcei(sources[i], AL_LOOPING, AL_TRUE)
            
            // Set Source Position
            if i == 0 {
                let sourcePosAL: [Float] = [Float(sourcePos.x), kDefaultDistance, Float(sourcePos.y)]
                alSourcefv(sources[i], AL_POSITION, sourcePosAL)
            }
            
            if i == 1 {
                let sourcePosAL2: [Float] = [Float(sourcePos2.x), kDefaultDistance, Float(sourcePos2.y)]
                alSourcefv(sources[i], AL_POSITION, sourcePosAL2)
            }
            
            // Set Source Reference Distance
            alSourcef(sources[i], AL_REFERENCE_DISTANCE, 50.0)
            
            // attach OpenAL Buffer to OpenAL Source
            alSourcei(sources[i], AL_BUFFER, ALint(buffers[i]))
        }
        
        error = alGetError()
        if error != AL_NO_ERROR {
            fatalError("Error attaching buffer to source: \(error)\n")
        }
    }
    
    
    func initOpenAL() {
        var error: ALenum = AL_NO_ERROR
        
        // Create a new OpenAL Device
        // Pass NULL to specify the system’s default output device
        device = alcOpenDevice(nil)
        if device != nil {
            // Create a new OpenAL Context
            // The new context will render to the OpenAL Device just created
            context = alcCreateContext(device, nil)
            if context != nil {
                // Make the new context the Current OpenAL Context
                alcMakeContextCurrent(context)
                
                // Create some OpenAL Buffer Objects
                alGenBuffers(2, &buffers)
                error = alGetError()
                if error != AL_NO_ERROR {
                    fatalError("Error Generating Buffers: \(error)")
                }
                
                // Create some OpenAL Source Objects
                alGenSources(2, &sources)
                if alGetError() != AL_NO_ERROR {
                    fatalError("Error generating sources! \(error)\n")
                }
                
            }
        }
        // clear any errors
        alGetError()
        
        self.initBuffer()
        self.initSource()
    }
    
    func teardownOpenAL() {
        // Delete the Sources
        alDeleteSources(2, &sources)
        // Delete the Buffers
        alDeleteBuffers(2, &buffers)
        
        //Release context
        alcDestroyContext(context)
        //Close device
        alcCloseDevice(device)
    }
    
    //MARK: Play / Pause
    
    func startSound() {
        var error: ALenum = AL_NO_ERROR
        
        NSLog("Start!\n")
        // Begin playing our source file
        alSourcePlay(sources[0])
        alSourcePlay(sources[1])
        error = alGetError()
        if error != AL_NO_ERROR {
            NSLog("error starting source: %x\n", error)
        } else {
            // Mark our state as playing (the view looks at this)
            self.isPlaying = true
        }
    }
    
    func stopSound() {
        var error: ALenum = AL_NO_ERROR
        
        NSLog("Stop!!\n")
        // Stop playing our source file
        alSourceStop(sources[0])
        alSourceStop(sources[1])
        error = alGetError()
        if error != AL_NO_ERROR {
            NSLog("error stopping source: %x\n", error)
        } else {
            // Mark our state as not playing (the view looks at this)
            self.isPlaying = false
        }
    }
    
    //MARK: Setters / Getters
    
    // The coordinates of the sound source
    private var _sourcePos: CGPoint = CGPoint()
    dynamic var sourcePos: CGPoint {
        get {
            return self._sourcePos
        }
        
        set(SOURCEPOS) {
            self._sourcePos = SOURCEPOS
            let sourcePosAL: [Float] = [Float(self._sourcePos.x), kDefaultDistance, Float(self._sourcePos.y)]
            // Move our audio source coordinates
            alSourcefv(sources[0], AL_POSITION, sourcePosAL)
        }
    }
    
    private var _sourcePos2: CGPoint = CGPoint()
    dynamic var sourcePos2: CGPoint {
        get {
            return self._sourcePos2
        }
        
        set(SOURCEPOS2) {
            self._sourcePos = SOURCEPOS2
            let sourcePosAL2: [Float] = [Float(self._sourcePos2.x), kDefaultDistance, Float(self._sourcePos2.y)]
            // Move our audio source coordinates
            alSourcefv(sources[1], AL_POSITION, sourcePosAL2)
        }
    }
    
    // The coordinates of the listener
    private var _listenerPos: CGPoint = CGPoint()
    dynamic var listenerPos: CGPoint {
        get {
            return self._listenerPos
        }
        
        set(LISTENERPOS) {
            self._listenerPos = LISTENERPOS
            let listenerPosAL: [Float] = [Float(self._listenerPos.x), 0.0, Float(self._listenerPos.y)]
            // Move our listener coordinates
            alListenerfv(AL_POSITION, listenerPosAL)
        }
    }
    
    
    
    // The rotation angle of the listener in radians
    private var _listenerRotation: CGFloat = 0
    dynamic var listenerRotation: CGFloat {
        get {
            return self._listenerRotation
        }
        
        set(radians) {
            self._listenerRotation = radians
            let ori: [Float] = [Float(cos(radians + M_PI_2.g)), Float(sin(radians + M_PI_2.g)), 0.0, 0.0, 0.0, 1.0]
            
            // Set our listener orientation (rotation)
            alListenerfv(AL_ORIENTATION, ori)
        }
    }
}