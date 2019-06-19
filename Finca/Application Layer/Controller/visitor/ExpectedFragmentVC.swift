//
//  ExpectedFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ExpectedFragmentVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
extension ExpectedFragmentVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "EXPECTED"
    }
    
    
}
