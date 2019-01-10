//
//  SwitchTableViewCell.swift
//  WhatToHideInNavigationController
//
//  Created by Yuichi Fujiki on 1/10/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switched(isOn: Bool, for title: String?)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!

    weak var delegate: SwitchTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switched(_ sender: Any) {
        let newValue = (sender as! UISwitch).isOn
        delegate?.switched(isOn: newValue, for: titleLabel?.text)
    }
}
