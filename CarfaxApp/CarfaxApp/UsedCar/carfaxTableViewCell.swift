//
//  carfaxTableViewCell.swift
//  CarfaxApp
//
//  Created by Twinkle Trivedi on 2020-10-04.
//  Copyright © 2020 Twinkle Trivedi. All rights reserved.
//

import UIKit

class carfaxTableViewCell: UITableViewCell {

    @IBOutlet weak var VehiclePhoto: UIImageView!
    
    @IBOutlet weak var VehicleDetails1lbl: UILabel!

    @IBOutlet weak var VehicleDetails2lbl: UILabel!
    
    
    @IBOutlet weak var callDealerBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
