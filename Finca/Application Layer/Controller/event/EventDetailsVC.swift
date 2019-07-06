//
//  EventDetailsVC.swift
//  Finca
//
//  Created by anjali on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class EventDetailsVC: BaseVC {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var bNo: UIButton!
    @IBOutlet weak var bYes: UIButton!
    
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var lbAttendPerson: UILabel!
    @IBOutlet weak var lbAttentStatus: UILabel!
    var eventModeL:ModelEvent!
    
    var attendPerson = ""
    var notes_person   = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lbTitle.text = eventModeL.event_title
         lbDesc.text = eventModeL.event_description
        lbDate.text = eventModeL.event_start_date + " To" +  eventModeL.event_end_date
        
        
        if eventModeL.going_person == "0" {
            bNo.isHidden = true
            bYes.setTitle("EDIT", for: .normal)
            
        }
        
        if eventModeL.numberof_person != nil {
             lbAttendPerson.text = eventModeL.numberof_person
           attendPerson = eventModeL.numberof_person
            
        }
        if eventModeL.notes_person != nil {
            lbNote.text = eventModeL.notes_person
            notes_person = eventModeL.notes_person
            
        }
    }
    

    @IBAction func onClickBAck(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickYes(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idAttendEventVC") as! AttendEventVC
           if bYes.currentTitle == "EDIT" {
            print("click edit")
            vc.attendPerson = attendPerson
            vc.note = notes_person
            vc.event_id = eventModeL.event_id
            vc.isShowDelet = true
            
        } else {
            vc.attendPerson = attendPerson
            vc.noOfAttent = notes_person
             vc.event_id = eventModeL.event_id
            vc.isShowDelet = false
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func onClickNo(_ sender: Any) {
        doPopBAck()
    }
}
