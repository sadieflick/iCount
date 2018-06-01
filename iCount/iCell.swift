//
//  iCell.swift
//  iCount
//
//  Created by Sadie Flick on 5/23/18.
//  Copyright © 2018 Sadie Flick. All rights reserved.
//

import UIKit

class iCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timesPerPeriodLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var countButton: UIButton!
    var delegate: MyICountVC?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func countButtonPressed(_ sender: UIButton) {
        delegate?.countButtonPressed(cell: self)
    }
    
}
