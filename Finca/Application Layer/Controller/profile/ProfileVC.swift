//
//  ProfileVC.swift
//  Finca
//
//  Created by anjali on 20/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {
    @IBOutlet weak var bMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        doInintialRevelController(bMenu: bMenu)
        
    }
    

    

}
