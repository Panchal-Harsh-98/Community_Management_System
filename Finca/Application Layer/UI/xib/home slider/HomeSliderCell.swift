//
//  HomeSliderCell.swift
//  O Shreeji dental clinic
//
//  Created by anjali on 18/04/19.
//  Copyright © 2019 Silverwing Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class HomeSliderCell: UIView  {

    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivImage.contentMode = .scaleToFill
        
    }

}
