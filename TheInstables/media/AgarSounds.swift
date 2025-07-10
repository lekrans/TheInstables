//
//  AgarSounds.swift
//  TheInstables
//
//  Created by Michael Lekrans on 2025-07-09.
//

/// =====================================================
///    module:          `AgarSounds.swift`
///    Author:            `Michael Lekrans`
///    shortDesc:      `Collection of Sounds`
///    description:     `Collection of Sounds ordered hierarchical`
/// =====================================================

import SpriteKit
import AVFoundation

struct AgarSoundResource {
    let fileName: String
    let volume: Float
    let pitch: Float
    
    func fileNameNoExtension() -> String {
        return String(fileName.split(separator: ".").first ?? "")
    }
    
    func fileExtension() -> String {
        return String(fileName.split(separator: ".").last ?? "")
    }
    
    
}

struct AgarSounds {
    // type of sound
    struct construction {
        struct building {
            struct door {
                struct metal {
                    struct heavy {
                        struct hydraulic {
                            struct sliding {
                                static let opening = AgarSoundResource(fileName: "hydraulic1.wav", volume: 1.0, pitch: 1.0)
                                static let closing = AgarSoundResource(fileName: "hydraulic2.wav", volume: 1.0, pitch: 1.0)
                            } // sliding
                        } // hydraulic
                    } // heavy
                } // metal
                struct wood {
                    
                } // wood
            } // door
        } // Building
    } // Construction
    struct weapons {
        struct large {
            
        } // large
        struct medium {
            
        } // medium
        struct small {
            struct guns {
                struct cocking {
                    static let long = AgarSoundResource(fileName: "cocking1.wav", volume: 1.0, pitch: 1.0)
                    static let short = AgarSoundResource(fileName: "cocking2.wav", volume: 1.0, pitch: 1.0)
                } // cocking
            } // guns
            struct swords {
                
            } // swords
            struct spears {
                
            } // spears
            struct axes {
                
            } // axes
        } // small
    } // weapons
    struct effects {
        struct explosions {
                    //            static let small = AgarSoundResource(fileName: "explosion1.wav", volume: 1.0, pitch: 1.0)
                    //            static let medium = AgarSoundResource(fileName: "explosion2.wav", volume: 1.0, pitch: 1.0)
        } // explosions
        struct swooshes {
                static let short = AgarSoundResource(fileName: "swoosh.flac", volume: 1.0, pitch: 1.0)
        } // Swooshes
    } // effects
}

typealias AS = AgarSounds



let engine = AVAudioEngine()
let player = AVAudioPlayerNode()
let timePitch = AVAudioUnitTimePitch() // Controls pitch and rate

func playModifiedSound(fileName: String, rate: Float = 1.0, pitch: Float = 0.0) {
    let fileNameNoExt = String(fileName.split(separator: ".").first ?? "")
    let ext = String(fileName.split(separator: ".").last ?? "")
    guard let url = Bundle.main.url(forResource: fileNameNoExt, withExtension: ext),
          let file = try? AVAudioFile(forReading: url) else { return }
    
    engine.attach(player)
    engine.attach(timePitch)
    
    timePitch.rate = rate      // Playback rate (1.0 is normal)
    timePitch.pitch = pitch    // In cents, +1000 = 1 octave up
    
    engine.connect(player, to: timePitch, format: file.processingFormat)
    engine.connect(timePitch, to: engine.mainMixerNode, format: file.processingFormat)
    
    print("before engine start")
    try? engine.start()
    print("after engine start")
    
    player.scheduleFile(file, at: nil, completionHandler: nil)
    print("before play")
    player.play()
    print("after play")
}


