//
//  ViewController.swift
//  Audio Capture and Playback
//
//  Created by Deng tianyuan on 4/12/19.
//  Copyright © 2019 Deng tianyuan. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var recordBar: UIBarButtonItem!
    @IBOutlet weak var playBar: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

