//
//  settingTableViewCell.swift
//  AB3AD
//
//  Created by Apple on 07/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class settingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
