//
//  SwitchTableViewCell.swift
//  WhatToHideInNavigationController
//
//  Created by Yuichi Fujiki on 1/10/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit

class SwitchTableViewCellWithTextField: SwitchTableViewCell {
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()

        textField.delegate = self
        textField.returnKeyType = .done
    }
}

extension SwitchTableViewCellWithTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
