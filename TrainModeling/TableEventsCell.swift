//
//  TableEventsCell.swift
//  TrainModeling
//
//  Created by Максим on 21.04.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit

class TableEventsCell: UITableViewCell {

    @IBOutlet weak var trainId: UILabel!
    @IBOutlet weak var occuranceTime: UILabel!
    @IBOutlet weak var interval: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
