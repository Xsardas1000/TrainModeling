//
//  TableDetailStationCell.swift
//  TrainModeling
//
//  Created by Максим on 09.04.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit

class TableDetailStationCell: UITableViewCell {

    @IBOutlet weak var trainId: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var stationTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
