//
//  ViewController.swift
//  Screenie
//
//  Created by juger rash on 12.09.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {
    
    //Outlets -:
    @IBOutlet private weak var statusLbl : UILabel!
    @IBOutlet private weak var imagePicker : UISegmentedControl!
    @IBOutlet private weak var selectedImageView : UIImageView!
    @IBOutlet private weak var micToggle : UISwitch!
    @IBOutlet private weak var recordBtn : UIButton!
    
    //Variables -:
    var recorder = RPScreenRecorder.shared()
    private var isRecording : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Actions -:
    @IBAction func imageWasPicked(_ sender : UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            selectedImageView.image = UIImage(named: "skate")!
        case 1:
            selectedImageView.image = UIImage(named: "food")!
        case 2:
            selectedImageView.image = UIImage(named: "cat")!
        case 3:
            selectedImageView.image = UIImage(named: "nature")!
        default:
            selectedImageView.image = UIImage(named: "skate")!
        }
    }
    
    @IBAction func recordBtnWasPressed(_ sender : Any) {
        if !isRecording {
            startRecording()
        }else {
//            stopRecording()
        }
    }
    
    func startRecording(){
        guard recorder.isAvailable else {
            print("Recoder is not available")
            return
        }
        
        if micToggle.isOn {
            recorder.isMicrophoneEnabled = true
        }else {
            recorder.isMicrophoneEnabled = false
        }
        
        recorder.startRecording { (error) in
            guard error == nil else {
                print("There was an error to start recording : \(error!.localizedDescription)")
                return
            }
            
            print("Start recording")
            DispatchQueue.main.async {
                self.micToggle.isEnabled = false
                self.statusLbl.text = "Recording..."
                self.statusLbl.textColor = #colorLiteral(red: 0.8957869411, green: 0.2001414299, blue: 0.1402733624, alpha: 1)
                self.recordBtn.setTitle("Stop", for: .normal)
                self.recordBtn.setTitleColor(#colorLiteral(red: 0.8957869411, green: 0.2001414299, blue: 0.1402733624, alpha: 1), for: .normal)
                self.isRecording = true 
                
            }
            
        }
    }


}

