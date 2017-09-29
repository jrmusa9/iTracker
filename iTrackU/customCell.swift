//
//  customCell.swift
//  iTrackU
//
//  Created by Juan Riveros on 9/26/17.
//  Copyright © 2017 Juan Riveros. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var locationNumberLabel: UILabel!
    @IBOutlet weak var inTimeLabel: UILabel!
    @IBOutlet weak var outTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityZipCodeLabel: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    
}
