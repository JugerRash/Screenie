//
//  ViewController.swift
//  Screenie
//
//  Created by juger rash on 12.09.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController , RPPreviewViewControllerDelegate {
    
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
            stopRecording()
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
    
    func stopRecording(){
        print("in stop function")
        recorder.stopRecording { (preview, error) in
            guard preview != nil else {
                print("preview controller could not be used ")
                return
            }
            
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete.", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.recorder.discardRecording {
                    print("discarded your video done")
                }
            })
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            })
            
            alert.addAction(deleteAction)
            alert.addAction(editAction)
            
            self.present(alert, animated: true, completion: nil)
            
            self.isRecording = false
            self.viewReset()
        }
    }
    
    func viewReset(){
        micToggle.isEnabled = true
        statusLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        statusLbl.text = "Ready to Record"
        recordBtn.setTitleColor(#colorLiteral(red: 0.2830333114, green: 0.7150810361, blue: 0.3204445839, alpha: 1), for: .normal)
        recordBtn.setTitle("Record", for: .normal)
        
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }


}

