// Multiple Source OpenAL Playback Class
// Created By Alt-G

import UIKit
import AVFoundation

import OpenAL

typealias ALCcontext = COpaquePointer
typealias ALCdevice = COpaquePointer

let kDefaultDistance: Float = 25.0
let source_num = 4

@objc(oalPlayback_MultiTest)
class oalPlayback_MultiTest: NSObject {
    
    var sources = [ALuint](count: source_num, repeatedValue: 0);
    var buffers = [ALuint](count: source_num, repeatedValue: 0);
    var context: ALCcontext = nil
    var device: ALCdevice = nil
    
    // IMPLEMENT LIST
    var data0: UnsafeMutablePointer<Void> = nil
    var data1: UnsafeMutablePointer<Void> = nil
    var data2: UnsafeMutablePointer<Void> = nil
    var data3: UnsafeMutablePointer<Void> = nil
    
    var sourceVolume: ALfloat = 0
    // Whether the sound is playing or stopped
    dynamic var isPlaying: Bool = false
    // Whether playback was interrupted by the system
    var wasInterrupted: Bool = false
    var iPodIsPlaying: Bool = false
    
    //MARK: Object Init / Maintenance
    override init() {
        super.init()
        // Initial Position Will Be Set By View Controller
        self._sourcePos0 = CGPointMake(0, 0)
        self._sourcePos1 = CGPointMake(0, 0)
        self._sourcePos2 = CGPointMake(0, 0)
        self._sourcePos3 = CGPointMake(0, 0)
        
        // Initial Position Will Be Set By View Controller
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
        // Get Bundle Reference (Reference to the compiled application bundle)
        let bundle = NSBundle.mainBundle()
        
        // IMPLEMENT LIST
        // Source Info 0
        var format0: ALenum = 0
        var size0: ALsizei = 0
        var freq0: ALsizei = 0
        
        // Source Info 1
        var format1: ALenum = 0
        var size1: ALsizei = 0
        var freq1: ALsizei = 0
        
        // Source Info 2
        var format2: ALenum = 0
        var size2: ALsizei = 0
        var freq2: ALsizei = 0
        
        // Source Info 3
        var format3: ALenum = 0
        var size3: ALsizei = 0
        var freq3: ALsizei = 0
        
        // get some audio data from a wave file (resource in bundle)
        let fileURL0 = NSURL(fileURLWithPath: bundle.pathForResource("waves_water", ofType: "caf")!)
        let fileURL1 = NSURL(fileURLWithPath: bundle.pathForResource("rain_thunder", ofType: "caf")!)
        let fileURL2 = NSURL(fileURLWithPath: bundle.pathForResource("fire_crackling", ofType: "caf")!)
        let fileURL3 = NSURL(fileURLWithPath: bundle.pathForResource("jungle_birds", ofType: "caf")!)
        
        //  Use Support Function to Get File Information
        //  Should Implement Error Check Here
        data0 = MyGetOpenALAudioData(fileURL0, &size0, &format0, &freq0)
        data1 = MyGetOpenALAudioData(fileURL1, &size1, &format1, &freq1)
        data2 = MyGetOpenALAudioData(fileURL2, &size2, &format2, &freq2)
        data3 = MyGetOpenALAudioData(fileURL3, &size3, &format3, &freq3)
        
        // Check For Errors
        var error = alGetError()
        if error != AL_NO_ERROR {
            fatalError("error loading sound: \(error)\n")
        }
        
        // use the static buffer data API
        alBufferData(buffers[0], format0, data0, size0, freq0)
        alBufferData(buffers[1], format1, data1, size1, freq1)
        alBufferData(buffers[2], format2, data2, size2, freq2)
        alBufferData(buffers[3], format3, data3, size3, freq3)
        
        MyFreeOpenALAudioData(data0, size0)
        MyFreeOpenALAudioData(data1, size1)
        MyFreeOpenALAudioData(data2, size2)
        MyFreeOpenALAudioData(data3, size3)
        
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
        
        
        for i in 0...(source_num - 1) {
            // Turn Looping ON
            alSourcei(sources[i], AL_LOOPING, AL_TRUE)
            
            // Set Source Position
            // Might Be Uncessary, can set Source Position In View Controller
            if i == 0 {
                let sourcePosAL0: [Float] = [Float(sourcePos0.x), kDefaultDistance, Float(sourcePos0.y)]
                alSourcefv(sources[i], AL_POSITION, sourcePosAL0)
            }
            
            if i == 1 {
                let sourcePosAL1: [Float] = [Float(sourcePos1.x), kDefaultDistance, Float(sourcePos1.y)]
                alSourcefv(sources[i], AL_POSITION, sourcePosAL1)
            }
            
            if i == 2 {
                let sourcePosAL2: [Float] = [Float(sourcePos2.x), kDefaultDistance, Float(sourcePos2.y)]
                alSourcefv(sources[i], AL_POSITION, sourcePosAL2)
            }
            
            if i == 3 {
                let sourcePosAL3: [Float] = [Float(sourcePos3.x), kDefaultDistance, Float(sourcePos3.y)]
                alSourcefv(sources[i], AL_POSITION, sourcePosAL3)
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
                alGenBuffers(Int32(source_num), &buffers)
                error = alGetError()
                if error != AL_NO_ERROR {
                    fatalError("Error Generating Buffers: \(error)")
                }
                
                // Create some OpenAL Source Objects
                alGenSources(Int32(source_num), &sources)
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
        alDeleteSources(Int32(source_num), &sources)
        // Delete the Buffers
        alDeleteBuffers(Int32(source_num), &buffers)
        
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
        for i in 0...(source_num - 1) {
                    alSourcePlay(sources[i])
            }
        
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
        for i in 0...(source_num - 1) {
            alSourceStop(sources[i])
        }
        
        error = alGetError()
        if error != AL_NO_ERROR {
            NSLog("error stopping source: %x\n", error)
        } else {
            // Mark our state as not playing (the view looks at this)
            self.isPlaying = false
        }
    }
    
//------------------------------------------------------------------------------
// Getters And Setters for Sources and Listener
// - Should Be Converted to utilize a list implementation.
    
    // Source[0]
    private var _sourcePos0: CGPoint = CGPoint()
    dynamic var sourcePos0: CGPoint {
        get {
            return self._sourcePos0
        }
        
        set(SOURCEPOS0) {
            self._sourcePos0 = SOURCEPOS0
            let sourcePosAL0: [Float] = [Float(self._sourcePos0.x), kDefaultDistance, Float(self._sourcePos0.y)]
            // Move our audio source coordinates
            alSourcefv(sources[0], AL_POSITION, sourcePosAL0)
        }
    }
    
    // Source[1]
    private var _sourcePos1: CGPoint = CGPoint()
    dynamic var sourcePos1: CGPoint {
        get {
            return self._sourcePos1
        }
        
        set(SOURCEPOS1) {
            self._sourcePos1 = SOURCEPOS1
            let sourcePosAL1: [Float] = [Float(self._sourcePos1.x), kDefaultDistance, Float(self._sourcePos1.y)]
            // Move our audio source coordinates
            alSourcefv(sources[1], AL_POSITION, sourcePosAL1)
        }
    }
    
    // Source[2]
    private var _sourcePos2: CGPoint = CGPoint()
    dynamic var sourcePos2: CGPoint {
        get {
            return self._sourcePos2
        }
        
        set(SOURCEPOS2) {
            self._sourcePos2 = SOURCEPOS2
            let sourcePosAL2: [Float] = [Float(self._sourcePos2.x), kDefaultDistance, Float(self._sourcePos2.y)]
            // Move our audio source coordinates
            alSourcefv(sources[2], AL_POSITION, sourcePosAL2)
        }
    }
    
    // Source[3]
    private var _sourcePos3: CGPoint = CGPoint()
    dynamic var sourcePos3: CGPoint {
        get {
            return self._sourcePos3
        }
        
        set(SOURCEPOS3) {
            self._sourcePos3 = SOURCEPOS3
            let sourcePosAL3: [Float] = [Float(self._sourcePos3.x), kDefaultDistance, Float(self._sourcePos3.y)]
            // Move our audio source coordinates
            alSourcefv(sources[3], AL_POSITION, sourcePosAL3)
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