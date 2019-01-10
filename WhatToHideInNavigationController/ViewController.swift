//
//  ViewController.swift
//  WhatToHideInNavigationController
//
//  Created by Yuichi Fujiki on 1/10/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let hidingList: [String: [String: String]] = [
        "UINavigationController": [
            "setNavigationBarHidden(:, animated:)": "Hides navigation bar.",
            "setToolBarHidden(:, animated:)": "Hides toolbar",
            "hidesBarsOnTap": "Navigation/Toolbars hide when you tap on the bars",
            "hidesBarsOnSwipe": "Navigation/Toolbars hide when you swipe up/down the scroll view",
            "hidesBarsWhenVerticallCompact": "Navigation/Toolbars hide when you rotate horizontally on the phone devices (except for plus and X devices)",
            "hidesBarsWhenKeyboardAppears": "Navigation/Toolbars hide when keyboard appears"
        ],
        "UINavigationItem": [
            "hidesSearchBarWhenScrolling": "Hides search bar on the bottom of navigation bar when scrolling the scrollview"
        ],
        "UIViewController": [
            "prefersStatusBarHidden (override)": "Hides status bar when this view controller is visible",
            "prefersHomeIndicatorAutoHidden (override)": "Hides home indicator (back button) when this view controller is shown",
            "hidesBottomBarWhenPushed": "Hides bottom bar when this view controller is visible"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "What to hide on navigation controller"
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchTableViewCell")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return hidingList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = Array(hidingList.keys.sorted())[section]
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = Array(hidingList.keys.sorted())[section]
        let listInSection = hidingList[title]!
        return listInSection.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = Array(hidingList.keys.sorted())[indexPath.section]
        let listInSection = hidingList[sectionTitle]!
        let rowTitle = Array(listInSection.keys.sorted())[indexPath.row]
        let rowDescription = listInSection[rowTitle]

        let cell = tableView.dequeueReusableCell(withIdentifier: "switchTableViewCell") as! SwitchTableViewCell
        cell.titleLabel.text = rowTitle
        cell.descriptionLabel.text = rowDescription
        cell.switch.isOn = false

        return cell
    }

}



