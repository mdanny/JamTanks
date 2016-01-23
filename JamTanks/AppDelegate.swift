//
//  AppDelegate.swift
//  JamTanks
//
//  Created by Macrinici Dan on 12/19/15.
//  Copyright (c) 2015 Swagler Enterprise. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        let scene = GameScene(size:self.skView.bounds.size)
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            self.skView!.presentScene(scene)
            
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

