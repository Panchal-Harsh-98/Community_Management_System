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
    
    var eventModeL:ModelEvent!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lbTitle.text = eventModeL.event_title
         lbDesc.text = eventModeL.event_description
        lbDate.text = eventModeL.event_start_date + " To" +  eventModeL.event_end_date
    }
    

    @IBAction func onClickBAck(_ sender: Any) {
        doPopBAck()
    }
    
}
